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
    
    enum CodingKeys: String, CodingKey {
        case idShow = "_id"
        case title
        case imageUrl
        case likesCount
    }
}

struct ShowDetails: Codable {
    let idShow: String
    let title: String
    let description: String?
    let imageUrl: String
    let episodeNumber: String?
    let season: String?
    
    enum CodingKeys: String, CodingKey {
        case idShow = "_id"
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
    }
}

struct Episodes: Codable {
    let showId: String
    let mediaId: String?
    let title: String
    let description: String
    let episodeNumber: String
    let season: String
    
    enum CodingKeys: String, CodingKey {
        case showId
        case mediaId
        case title
        case description
        case episodeNumber
        case season
    }
}

struct Media: Codable {
    let mediaId: String?
    let mimeType: String?
    let withName: String?
    let fileName: String?
    
    enum CodingKeys: String, CodingKey {
        case mediaId
        case mimeType
        case withName
        case fileName
    }
}
