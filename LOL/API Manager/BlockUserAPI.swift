//
//  BlockUserAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 27/08/24.
//

import Alamofire

protocol BlockUserApiServiceProtocol {
    func blockUser(ip: String, completion: @escaping (Result<BlockUser, Error>) -> Void)
}

class BlockUserApiService: BlockUserApiServiceProtocol {
    static let shared = BlockUserApiService()
    
    private init() {}
    
    func blockUser(ip: String, completion: @escaping (Result<BlockUser, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: ConstantValue.user_name) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username not found"])))
            return
        }
        
        let url = "https://lolcards.link/api/block-user"
        let parameters: [String: String] = ["username": username, "block": ip]
        
        AF.request(url, method: .post, parameters: parameters, encoder: .urlEncodedForm)
            .validate()
            .responseDecodable(of: BlockUser.self) { response in
                switch response.result {
                case .success(let blockUserResponse):
                    if blockUserResponse.status == 1 {
                        completion(.success(blockUserResponse))
                    } else {
                        completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid status"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
