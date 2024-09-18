//
//  MoreAppAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 16/08/24.
//

import Foundation
import Alamofire

protocol MoreAppApiServiceProtocol {
    func postMoreData(packageName: String, language: String, completion: @escaping (Result<MoreApp, Error>) -> Void)
}

class MoreAppAPIService: MoreAppApiServiceProtocol {
    static let shared = MoreAppAPIService()
    
    private init() {}
    
    func postMoreData(packageName: String, language: String, completion: @escaping (Result<MoreApp, Error>) -> Void) {
        let url = "https://lolcards.link/api/moreapp"
        let parameters: [String: String] = ["packageName": packageName, "language": language]
        
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            .responseDecodable(of: MoreApp.self) { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
    }
}
