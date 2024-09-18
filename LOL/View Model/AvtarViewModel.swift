//
//  AvtarViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 02/08/24.
//

import Foundation

class AvatarViewModel {
    var avatars: [Dataa] = []
    var onAvatarsFetched: (() -> Void)?
    var onFetchError: ((Error) -> Void)?
    
    func fetchAvatars() {
        AvatarAPIManager.shared.fetchAvatars { [weak self] result in
            switch result {
            case .success(let avatarResponse):
                DispatchQueue.global(qos: .background).async {
                    self?.avatars = avatarResponse.data
                    DispatchQueue.main.async {
                        self?.onAvatarsFetched?()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onFetchError?(error)
                }
            }
        }
    }
}
