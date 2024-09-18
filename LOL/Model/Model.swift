//
//  Model.swift
//  LOL
//
//  Created by Arpit iOS Dev. on 31/07/24.
//

import Foundation
import UIKit

// MARK: - UserNameResponse
struct UserNameResponse: Codable {
    let userNameStatus: Bool
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case userNameStatus = "UserNameStatus"
        case message
    }
}

// MARK: - Avatar
struct Avatar: Codable {
    let status: Int
    let message: String
    let data: [Dataa]
}
struct Dataa: Codable {
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatarUrl"
    }
}

// MARK: - RegisterProfile
struct RegisterProfile: Codable {
    let status: Int
    let message: String
    let data: DataClass
}
struct DataClass: Codable {
    let name: String
    let avatar: String
    let username, link: String
    let isPurchase: Bool
}

// MARK: - SelectedCardTitle
struct SelectedCardTitle: Codable {
    let status: Int
    let message: String
    let data: SelectCardTitleData
}
struct SelectCardTitleData: Codable {
    let selectedCardTitle: [String]
    let finallanguage: String
}

// MARK: - CardTitle
struct CardTitle: Codable {
    let status: Int
    let message: String
    let data: CardData
}
struct CardData: Codable {
    let cardTitle, indices: [String]
}

// MARK: - UpdateCardtTitle
struct SelectCardTitle: Codable {
    let status: Int
    let message: String
    let data: UpdateCardData
}
struct UpdateCardData: Codable {
    let cardTitle, selectedCardTitle: [String]
}

// MARK: - UpdateCardTitle
struct UpdateCardTitle: Codable {
    let status: Int
    let message: String
}

// MARK: - DeleteUser
struct DeleteUser: Codable {
    let status: Int
    let message: String
}

// MARK: - MoreApp
struct MoreApp: Codable {
    let status: Int
    let message: String
    let data: [MoreData]
}
struct MoreData: Codable {
    let appName: String
    let logo: String
    let appID, packageName: String
    
    enum CodingKeys: String, CodingKey {
        case appName, logo
        case appID = "appId"
        case packageName
    }
}

// MARK: - PremiumModel
struct PremiumModel {
    let id: Int
    let title: String
    let description: String
    let image: UIImage
}

// MARK: - InboxCardShow
struct InboxCardShow: Codable {
    let status: Int
    let message: String
    let data: [InboxData]
}
struct InboxData: Codable {
    let id: String
    let bgURL: String
    let selectedCardTitle: [SelectedCardQuestion]
    let avatar: String
    let hint, nickname, location, country: String
    let ip, time: String
    let read: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case bgURL = "bgUrl"
        case selectedCardTitle, avatar, hint, nickname, location, country, ip, time, read
    }
}
struct SelectedCardQuestion: Codable {
    let title, ans, id: String
    
    enum CodingKeys: String, CodingKey {
        case title, ans
        case id = "_id"
    }
}

// MARK: - Welcome
struct InboxUpdateCardShow: Codable {
    let status: Int
    let message: String
}

// MARK: - BlockUser
struct BlockUser: Codable {
    let status: Int
    let message: String
}

// MARK: - DeleteInbox
struct DeleteInbox: Codable {
    let status: Int
    let message: String
}

// MARK: - Purchase
struct Purchase: Codable {
    let status: Int
    let message: String
}

// MARK: - pauseLink
struct pauseLink: Codable {
    let status: Int
    let message: String
}
