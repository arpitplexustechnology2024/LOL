//
//  PauseLinkViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 05/09/24.
//

import Foundation
import Alamofire

class PauseLinkViewModel {
    
    private let pauseLinkApiService: PauseLinkApiServiceProtocol
    
    var onCompletion: ((Result<pauseLink, Error>) -> Void)?
    var onNoInternet: (() -> Void)?
    
    init(apiService: PauseLinkApiServiceProtocol) {
        self.pauseLinkApiService = apiService
    }
    
    func updatePauseLink(username: String, isPaused: Bool) {
        guard isConnectedToInternet() else {
            onNoInternet?()
            return
        }
        
        let pauseLinkValue = isPaused ? "true" : "false"
        let parameters: [String: Any] = [
            "username": username,
            "pauseLink": pauseLinkValue
        ]
        
        pauseLinkApiService.updatePauseLink(parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                self?.onCompletion?(.success(response))
            case .failure(let error):
                self?.onCompletion?(.failure(error))
            }
        }
    }
    
    private func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
