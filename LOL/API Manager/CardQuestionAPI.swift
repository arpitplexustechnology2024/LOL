//
//  CardTitleAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import Foundation
import Alamofire

protocol CardQuestionApiServiceProtocol {
    func fetchCardTitle(language: String, completion: @escaping (Result<SelectedCardTitle, Error>) -> Void)
}

class CardQuestionApiService: CardQuestionApiServiceProtocol {
    static let shared = CardQuestionApiService()
    
    private init() {}
    
    func fetchCardTitle(language: String, completion: @escaping (Result<SelectedCardTitle, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: ConstantValue.user_name) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username not found"])))
            return
        }
        
        let url = "https://lolcards.link/api/findTitle"
        let parameters: [String: String] = ["username": username, "language": language]
        
        AF.request(url, method: .post, parameters: parameters, encoder: .urlEncodedForm)
            .validate()
            .responseDecodable(of: SelectedCardTitle.self) { response in
                switch response.result {
                case .success(let result):
                    if result.status == 1 {
                        completion(.success(result))
                    } else {
                        completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid status"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
