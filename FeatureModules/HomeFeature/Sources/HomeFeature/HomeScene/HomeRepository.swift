//
//  HomeRepository.swift
//  HomeModule
//
//  Created by Özcan AKKOCA on 28.01.2025.
//
//

import Foundation
import CoreNetwork

protocol HomeRepositoryProtocol: AnyObject {
    func getLocations() async throws -> [String]
}

final class HomeRepository: BaseRepository, HomeRepositoryProtocol {
    
    func getLocations() async throws -> [String] {
        return try await service.fetchData(model: HttpModel.General.getLocations())
    }
}
