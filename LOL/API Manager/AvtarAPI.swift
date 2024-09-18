//
//  AvtarAPI.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 02/08/24.
//

import Alamofire

class AvatarAPIManager {
    static let shared = AvatarAPIManager()
    
    private init() {}
    
    func isConnectedToInternet() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return networkManager?.isReachable ?? false
    }
    
    func fetchAvatars(completion: @escaping (Result<Avatar, Error>) -> Void) {
        let url = "https://lolcards.link/api/avatar"
        
        guard isConnectedToInternet() else {
            completion(.failure(NSError(domain: "", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection"])))
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .post).validate().responseDecodable(of: Avatar.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let avatarResponse):
                        if avatarResponse.status == 1 {
                            completion(.success(avatarResponse))
                        } else {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: avatarResponse.message])
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
