//
//  PauseLinkAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 05/09/24.
//

import Foundation
import Alamofire

protocol PauseLinkApiServiceProtocol {
    func updatePauseLink(parameters: [String: Any], completion: @escaping (Result<pauseLink, Error>) -> Void)
}

class PauseLinkApiService: PauseLinkApiServiceProtocol {
    
    static let shared = PauseLinkApiService()
    
    private init() {}
    
    func updatePauseLink(parameters: [String: Any], completion: @escaping (Result<pauseLink, Error>) -> Void) {
        let url = "https://lolcards.link/api/pause-link"
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: pauseLink.self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
