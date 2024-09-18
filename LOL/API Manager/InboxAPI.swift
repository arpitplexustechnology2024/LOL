//
//  InboxAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 22/08/24.
//

import Alamofire

protocol InboxApiServiceProtocol {
    func fetchCardTitle(completion: @escaping (Result<InboxCardShow, Error>) -> Void)
    func updateInboxStatus(inboxId: String, completion: @escaping (Result<InboxUpdateCardShow, Error>) -> Void)
}

class InboxApiService: InboxApiServiceProtocol {
    
    static let shared = InboxApiService()
    
    private init() {}
    
    func fetchCardTitle(completion: @escaping (Result<InboxCardShow, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: ConstantValue.user_name) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username not found"])))
            return
        }
        
        let url = "https://lolcards.link/api/inbox"
        let parameters: [String: String] = ["username": username]
        
        AF.request(url, method: .post, parameters: parameters, encoder: .urlEncodedForm)
            .validate()
            .responseDecodable(of: InboxCardShow.self) { response in
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
    
    func updateInboxStatus(inboxId: String, completion: @escaping (Result<InboxUpdateCardShow, any Error>) -> Void) {
        let url = "https://lolcards.link/api/inbox/read/update"
        let parameters: [String: String] = [
            "inboxId": inboxId,
            "read": "true"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoder: .urlEncodedForm)
            .validate()
            .responseDecodable(of: InboxUpdateCardShow.self) { response in
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
