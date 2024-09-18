//
//  RegisterViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 06/08/24.
//

import Foundation

class RegisterViewModel {
    private let apiService: RegisterAPIServiceProtocol
    var registerProfile: RegisterProfile?
    
    init(apiService: RegisterAPIServiceProtocol = RegisterAPIService.shared) {
        self.apiService = apiService
    }
    
    func registerUser(name: String, avatar: String, username: String, deviceToken: String, completion: @escaping (Result<RegisterProfile, Error>) -> Void) {
        
        let language: String
        if #available(iOS 16.0, *) {
            language = Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            language = Locale.current.languageCode ?? "en"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.registerUser(name: name, avatar: avatar, username: username, language: language, deviceToken: deviceToken) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        self.registerProfile = profile
                        completion(.success(profile))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
