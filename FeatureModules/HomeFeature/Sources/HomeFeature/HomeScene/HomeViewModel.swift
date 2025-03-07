//
//  HomeViewModel.swift
//  HomeModule
//
//  Created by Özcan AKKOCA on 28.01.2025.
//
//

import Foundation
import CoreNetwork
import CoreLocation
import CoreResource
import MapKit

protocol HomeViewModelProtocol: AnyObject {
    // Add your custom methods here
    var isTracking: Bool { get set }
    var lastRecordedLocation: CLLocation? { get set }
    var outputHandler: ((HomeViewModel.HomeOutput) -> Void)? { set get }
    
    func startTracking()
    func stopTracking()
    func resetRoute()
    func handleLocationUpdate(_ location: CLLocation) -> MKPointAnnotation?
    func handleInitialLocation(_ location: CLLocation) -> MKPointAnnotation
    func loadData()
    func showLocationPermissionAlert()
}

final class HomeViewModel {
    
    enum HomeOutput {
        case setLoading(_ isLoading: Bool)
        case showError(_ message: String)
        case updateTrackingStatus(_ isTracking: Bool)
        case showLocationPermissionAlert
    }
    
    // Add location properties
    var isTracking: Bool = true
    var lastRecordedLocation: CLLocation?
    private let minimumDistanceThreshold: CLLocationDistance = 100
    
    var outputHandler: ((HomeOutput) -> Void)?
    
    private let router: HomeRouterProtocol
    private let service: HomeRepositoryProtocol
    
    init(router: HomeRouterProtocol,
         service: HomeRepositoryProtocol) {
        self.router = router
        self.service = service
    }
}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
    func loadData() {

    }
    
    func startTracking() {
        isTracking = true
        outputHandler?(.updateTrackingStatus(true))
    }
    
    func stopTracking() {
        isTracking = false
        outputHandler?(.updateTrackingStatus(false))
    }
    
    func resetRoute() {
        lastRecordedLocation = nil
    }
    
    func handleLocationUpdate(_ location: CLLocation) -> MKPointAnnotation? {
        if let lastLocation = lastRecordedLocation {
            let distance = location.distance(from: lastLocation)
            if distance >= minimumDistanceThreshold {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = CoreLocalize.Home.LocationUpdate
                lastRecordedLocation = location
                return annotation
            }
        } else {
            lastRecordedLocation = location
        }
        return nil
    }
    
    func handleInitialLocation(_ location: CLLocation) -> MKPointAnnotation {
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = location.coordinate
        startAnnotation.title = CoreLocalize.Home.Start
        return startAnnotation
    }
    
    func showLocationPermissionAlert() {
        outputHandler?(.showLocationPermissionAlert)
    }
}
