//
//  RegisterAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 06/08/24.
//

import Alamofire

protocol RegisterAPIServiceProtocol {
    func registerUser(name: String, avatar: String, username: String, language: String, deviceToken: String, completion: @escaping (Result<RegisterProfile, Error>) -> Void)
}

class RegisterAPIService: RegisterAPIServiceProtocol {
    static let shared = RegisterAPIService()
    
    private init() {}
    
    func registerUser(name: String, avatar: String, username: String, language: String, deviceToken: String, completion: @escaping (Result<RegisterProfile, Error>) -> Void) {
        let url = "https://lolcards.link/api/register"
        let parameters: [String: String] = [
            "name": name,
            "avatar": avatar,
            "username": username,
            "language": language,
            "deviceToken": deviceToken
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            .responseDecodable(of: RegisterProfile.self) { response in
                switch response.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        completion(.success(data))
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
    }
}
