//
//  DeleteInbox.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 27/08/24.
//

import Alamofire

protocol DeleteInboxApiServiceProtocol {
    func deleteInbox(inboxId: String, completion: @escaping (Result<DeleteInbox, Error>) -> Void)
}

class DeleteInboxApiService: DeleteInboxApiServiceProtocol {
    static let shared = DeleteInboxApiService()
    
    private init() {}
    
    func deleteInbox(inboxId: String, completion: @escaping (Result<DeleteInbox, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: ConstantValue.user_name) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username not found"])))
            return
        }
        
        let url = "https://lolcards.link/api/inbox/delete"
        let parameters: [String: String] = ["username": username, "inboxId": inboxId]
        
        AF.request(url, method: .post, parameters: parameters, encoder: .urlEncodedForm)
            .validate()
            .responseDecodable(of: DeleteInbox.self) { response in
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
