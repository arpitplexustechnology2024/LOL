//
//  DeleteUserViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 13/08/24.
//

import Foundation

class DeleteuserViewModel {
    private let apiService: DeleteUserApiServiceProtocol
    var deleteProfile: DeleteUser?
    
    init(apiService: DeleteUserApiServiceProtocol = DeleteuserApiService.shared) {
        self.apiService = apiService
    }
    
    func requestDeleteUser(username: String, completion: @escaping (Result<DeleteUser, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.requestDeleteUser(username: username) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        self.deleteProfile = profile
                        completion(.success(profile))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
