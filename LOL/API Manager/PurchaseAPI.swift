//
//  PurchaseAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 11/09/24.
//

import Foundation
import Alamofire

protocol PurchaseApiServiceProtocol {
    func updatePurchase(completion: @escaping (Result<Purchase, Error>) -> Void)
}

class PurchaseApiService: PurchaseApiServiceProtocol {
    
    static let shared = PurchaseApiService()
    
    private init() {}
    
    func updatePurchase(completion: @escaping (Result<Purchase, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: ConstantValue.user_name) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username not found"])))
            return
        }
        
        let url = "https://lolcards.link/api/purchase"
        let parameters: [String: String] = [
            "username": username,
            "purchase": "true"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: Purchase.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
