//
//  InboxViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 22/08/24.
//

import Foundation

class InboxViewModel {
    
    private let inboxApiService: InboxApiServiceProtocol
    
    var inboxData: [InboxData] = []
    var reloadData: (() -> Void)?
    var showError: ((String) -> Void)?
    
    init(apiService: InboxApiServiceProtocol) {
        self.inboxApiService = apiService
    }
    
    func fetchCardTitles() {
        inboxApiService.fetchCardTitle { [weak self] result in
            switch result {
            case .success(let inboxCardShow):
                self?.inboxData = inboxCardShow.data
                self?.reloadData?()
            case .failure(let error):
                self?.showError?(error.localizedDescription)
            }
        }
    }
    
    func updateInboxStatus(inboxId: String, completion: @escaping (Result<InboxUpdateCardShow, Error>) -> Void) {
        inboxApiService.updateInboxStatus(inboxId: inboxId) { [weak self] result in
            switch result {
            case .success(let inboxUpdateCardShow):
                completion(.success(inboxUpdateCardShow))
            case .failure(let error):
                self?.showError?(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
