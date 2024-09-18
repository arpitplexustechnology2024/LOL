//
//  DeleteInboxViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 27/08/24.
//

import Alamofire

class DeleteInboxViewModel {
    
    private let deleteInboxApiService: DeleteInboxApiServiceProtocol
    
    init(apiService: DeleteInboxApiServiceProtocol) {
        self.deleteInboxApiService = apiService
    }
    
    func deleteInbox(inboxId: String, completion: @escaping (Result<DeleteInbox, Error>) -> Void) {
        deleteInboxApiService.deleteInbox(inboxId: inboxId) { result in
            switch result {
            case .success(let deleteInboxResponse):
                completion(.success(deleteInboxResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
