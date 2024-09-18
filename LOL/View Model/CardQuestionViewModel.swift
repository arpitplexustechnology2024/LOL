//
//  CardTitleViewModel.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 09/08/24.
//

import Foundation

class CardQuestionViewModel {
    
    private let cardQuestionApiService: CardQuestionApiServiceProtocol
    
    var cardTitles: [String] = []
    var reloadData: (() -> Void)?
    var showError: ((String) -> Void)?
    
    init(apiService: CardQuestionApiServiceProtocol) {
        self.cardQuestionApiService = apiService
    }
    
    func fetchCardTitles() {
        
        let language: String
        if #available(iOS 16.0, *) {
            language = Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            language = Locale.current.languageCode ?? "en"
        }
        
        cardQuestionApiService.fetchCardTitle(language: language) { [weak self] result in
            switch result {
            case .success(let selectedCardTitle):
                self?.cardTitles = selectedCardTitle.data.selectedCardTitle
                self?.reloadData?()
            case .failure(let error):
                self?.showError?(error.localizedDescription)
            }
        }
    }
}
