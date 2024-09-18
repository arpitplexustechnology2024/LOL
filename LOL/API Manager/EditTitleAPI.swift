//
//  CardTitleAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import Alamofire

protocol EditTitleApiServiceProtocol {
    func fetchEditTitle(completion: @escaping (Result<CardTitle, Error>) -> Void)
    func selecteCardTitle(parameters: [String: String], completion: @escaping (Result<SelectCardTitle, Error>) -> Void)
    func updateCardTitle(parameters: [String: Any], completion: @escaping (Result<UpdateCardTitle, Error>) -> Void)
}

class EditTitleApiService: EditTitleApiServiceProtocol {
    static let shared = EditTitleApiService()
    
    private init() {}
    
    func fetchEditTitle(completion: @escaping (Result<CardTitle, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey:ConstantValue.user_name) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username not found"])))
            return
        }
        
        let url = "https://lolcards.link/api/cardTitle"
        let parameters: [String: String] = ["username": username]
        
        AF.request(url, method: .post, parameters: parameters, encoder: .urlEncodedForm)
            .validate()
            .responseDecodable(of: CardTitle.self) { response in
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
    
    func selecteCardTitle(parameters: [String: String], completion: @escaping (Result<SelectCardTitle, Error>) -> Void) {
        let url = "https://lolcards.link/api/select/cardTitle"
        
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            .validate()
            .responseDecodable(of: SelectCardTitle.self) { response in
                switch response.result {
                case .success(let updateCardTitle):
                    completion(.success(updateCardTitle))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func updateCardTitle(parameters: [String: Any], completion: @escaping (Result<UpdateCardTitle, Error>) -> Void) {
            let url = "https://lolcards.link/api/update/cardTitle"
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseDecodable(of: UpdateCardTitle.self) { response in
                    switch response.result {
                    case .success(let updateCardTitle):
                        completion(.success(updateCardTitle))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    }
