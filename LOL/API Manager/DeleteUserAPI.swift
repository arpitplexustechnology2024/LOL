//
//  DeleteUserAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 13/08/24.
//

import Foundation
import Alamofire

protocol DeleteUserApiServiceProtocol {
    func requestDeleteUser(username: String, completion: @escaping (Result<DeleteUser, Error>) -> Void)
}

class DeleteuserApiService: DeleteUserApiServiceProtocol {
    static let shared = DeleteuserApiService()
    
    private init() {}
    
    func requestDeleteUser(username: String, completion: @escaping (Result<DeleteUser, Error>) -> Void) {
        let url = "https://lolcards.link/api/delete"
        let parameters: [String: String] = ["username": username]
        
        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
            .responseDecodable(of: DeleteUser.self) { response in
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
