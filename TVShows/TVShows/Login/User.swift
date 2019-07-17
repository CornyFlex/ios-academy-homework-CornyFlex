//
//  User.swift
//  TVShows
//
//  Created by Infinum on 14/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}

struct LoginData: Codable {
    let token: String
}

struct Show: Codable {
    let idShow: String
    let title: String
    let imageUrl: String
    let likesCount: Int
    
    enum CodingKeysShows: String, CodingKey {
        case idShow = "_id"
        case title
        case imageUrl
        case likesCount
    }
}
