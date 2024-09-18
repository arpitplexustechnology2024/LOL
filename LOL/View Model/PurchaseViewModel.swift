//
//  PurchaseViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 11/09/24.
//

import Foundation
import Alamofire

class PurchaseViewModel {
    
    private let purchaseApiService: PurchaseApiServiceProtocol
    
    init(apiService: PurchaseApiServiceProtocol) {
        self.purchaseApiService = apiService
    }
    
    func updatePurchase(completion: @escaping (Result<Purchase, Error>) -> Void) {
        purchaseApiService.updatePurchase { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

