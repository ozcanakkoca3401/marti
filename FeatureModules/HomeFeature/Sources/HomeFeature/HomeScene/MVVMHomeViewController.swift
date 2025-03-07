//
//  MVVMHomeViewController.swift
//  HomeModule
//
//  Created by Özcan AKKOCA on 28.01.2025.
//
//

import UIKit
import MapKit
import SVProgressHUD
import CoreLocation
import SnapKit
import CoreExtension
import CoreResource

public final class MVVMHomeViewController: UIViewController {
    
    // MARK: - Views
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }()
    
    private let bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 12
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -2)
        bottomView.layer.shadowRadius = 4
        bottomView.layer.shadowOpacity = 0.1
        return bottomView
    }()
    
    private lazy var trackingButton: UIButton = {
        let trackingButton = UIButton(type: .system)
        trackingButton.setTitle(CoreLocalize.Home.StopTracking, for: .normal)
        trackingButton.backgroundColor = .systemBlue
        trackingButton.setTitleColor(.white, for: .normal)
        trackingButton.layer.cornerRadius = 8
        trackingButton.addTarget(self, action: #selector(trackingButtonTapped), for: .touchUpInside)
        return trackingButton
    }()
    
    private lazy var resetButton: UIButton = {
        let resetButton = UIButton(type: .system)
        resetButton.setTitle(CoreLocalize.Home.ResetRoute, for: .normal)
        resetButton.backgroundColor = .systemRed
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 8
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return resetButton

    }()

    // MARK: - Properties
    var viewModel: HomeViewModelProtocol!
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        return locationManager
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        bindViewModel()
    }

}

// MARK: - Binding
private extension MVVMHomeViewController {
    func bindViewModel() {
        viewModel.outputHandler = { [weak self] outputValue in
            DispatchQueue.main.async {
                self?.handleOutput(outputValue)
            }
        }
    }
    
    func handleOutput(_ output: HomeViewModel.HomeOutput) {
        switch output {
        case .setLoading(let isLoading):
            isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
        case .showError(let errorMessage):
            SVProgressHUD.showError(withStatus: errorMessage)
        case .updateTrackingStatus(_):
            break
        case .showLocationPermissionAlert:
            showLocationPermissionAlert()
        }
    }
    
    private func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: CoreLocalize.Home.LocationAccessRequired,
            message: CoreLocalize.Home.LocationPermissionMessage,
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: CoreLocalize.Home.Settings, style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: CoreLocalize.Home.Cancel, style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - UI
private extension MVVMHomeViewController {
    func setupUI() {
        title = CoreLocalize.Home.Title
        view.addSubviewAndMakeConstraints(mapView)
            
        view.addSubview(bottomView)
        bottomView.addSubview(trackingButton)
        bottomView.addSubview(resetButton)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        
        trackingButton.snp.makeConstraints { make in
            make.leading.equalTo(bottomView).offset(16)
            make.centerY.equalTo(bottomView)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        resetButton.snp.makeConstraints { make in
            make.trailing.equalTo(bottomView).offset(-16)
            make.centerY.equalTo(bottomView)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
    
    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - MKMapViewDelegate
extension MVVMHomeViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.strokeColor = UIColor.red
            circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.3)
            circleRenderer.lineWidth = 2
            return circleRenderer
        }
        return MKOverlayRenderer()
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = String(describing: AnnotationDetailView.self)
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.isEnabled = true
            annotationView?.isDraggable = true

            annotationView?.detailCalloutAccessoryView = AnnotationDetailView(
                latitude: annotation.coordinate.latitude,
                longitude: annotation.coordinate.longitude
            )
        }

        if let title = annotation.title, title == "Start" || title == "End" {
            (annotationView as? MKMarkerAnnotationView)?.markerTintColor = .blue
        } else {
            (annotationView as? MKMarkerAnnotationView)?.markerTintColor = .red
        }

        return annotationView
    }
}

extension MVVMHomeViewController: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            viewModel.showLocationPermissionAlert()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if viewModel.lastRecordedLocation == nil {
            let startAnnotation = viewModel.handleInitialLocation(location)
            mapView.addAnnotation(startAnnotation)
        }
        
        if let annotation = viewModel.handleLocationUpdate(location) {
            mapView.addAnnotation(annotation)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
    }
}

// MARK: - Actions
@objc private extension MVVMHomeViewController {
    func trackingButtonTapped() {
        if viewModel.isTracking {
            viewModel.stopTracking()
            trackingButton.setTitle(CoreLocalize.Home.StartTracking, for: .normal)
            locationManager.stopUpdatingLocation()
        } else {
            viewModel.startTracking()
            trackingButton.setTitle(CoreLocalize.Home.StopTracking, for: .normal)
            locationManager.startUpdatingLocation()
        }
    }
    
    func resetButtonTapped() {
        mapView.removeAnnotations(mapView.annotations.filter { $0 is MKPointAnnotation })
        viewModel.resetRoute()
        
        if let userLocation = locationManager.location, viewModel.isTracking {
            let startAnnotation = viewModel.handleInitialLocation(userLocation)
            mapView.addAnnotation(startAnnotation)
        }
    }
}
