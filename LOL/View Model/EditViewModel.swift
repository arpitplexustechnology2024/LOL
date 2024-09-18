//
//  EditViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import Foundation

class EditViewModel {
    private let editTitleApiService: EditTitleApiServiceProtocol
    
    var cardTitles: [String] = []
    var selectedIndices: [String] = []
    var editedTitles: [Int: String] = [:]
    var reloadData: (() -> Void)?
    var showError: ((String) -> Void)?
    
    init(apiService: EditTitleApiServiceProtocol) {
        self.editTitleApiService = apiService
    }
    
    func fetchCardTitles() {
        
        editTitleApiService.fetchEditTitle { [weak self] result in
            switch result {
            case .success(let titles):
                self?.cardTitles = titles.data.cardTitle
                self?.selectedIndices = titles.data.indices
                self?.reloadData?()
            case .failure(let error):
                self?.showError?(error.localizedDescription)
            }
        }
    }
    
    func selecteCardTitle(completion: @escaping (Result<SelectCardTitle, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: ConstantValue.user_name) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username not found."])))
            return
        }
        var parameters: [String: String] = ["username": username]
        for (index, selectedIndex) in selectedIndices.enumerated() {
            parameters["selectedcardTitle\(index)"] = selectedIndex
        }
        editTitleApiService.selecteCardTitle(parameters: parameters) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateCardTitle(completion: @escaping (Result<UpdateCardTitle, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: ConstantValue.user_name) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Username not found"])))
            return
        }
        
        guard !editedTitles.isEmpty else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No edited cells found"])))
            return
        }
        
        let sortedEditedTitles = editedTitles.sorted { $0.key < $1.key }
        
        let parameters: [String: Any] = [
            "username": username,
            "titleKey": sortedEditedTitles.map { $0.key },
            "titleValue": sortedEditedTitles.map { $0.value }
        ]
        
        editTitleApiService.updateCardTitle(parameters: parameters) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateEditedTitle(at index: Int, with newTitle: String) {
        editedTitles[index] = newTitle
    }
}
