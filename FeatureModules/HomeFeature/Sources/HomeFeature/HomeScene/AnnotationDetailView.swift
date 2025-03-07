import UIKit

final class AnnotationDetailView: UILabel {
    
    init(latitude: Double, longitude: Double) {
        super.init(frame: .zero)
        setupView(latitude: latitude, longitude: longitude)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(latitude: Double, longitude: Double) {
        numberOfLines = 0
        font = .systemFont(ofSize: 12)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let currentTime = dateFormatter.string(from: Date())
        
        text = String(format: "Lat: %.6f\nLong: %.6f\nTime: %@",
                      latitude,
                      longitude,
                      currentTime)
    }
}
