//
//  BlockUserViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 27/08/24.
//

import Alamofire

class BlockUserViewModel {
    
    private let blockUserApiService: BlockUserApiServiceProtocol
    
    init(apiService:BlockUserApiServiceProtocol) {
        self.blockUserApiService = apiService
    }
    
    func blockUser(ip: String, completion: @escaping (Result<BlockUser, Error>) -> Void) {
        blockUserApiService.blockUser(ip: ip) { result in
            switch result {
            case .success(let blockUserResponse):
                completion(.success(blockUserResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
