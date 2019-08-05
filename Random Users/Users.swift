//
//  Users.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Users: Decodable, Equatable {
    
    enum resultKey: String, CodingKey {
        case results
    }
    
    let results: [User]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: resultKey.self)
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        self.results = try resultsContainer.decode([User].self)
    
    }
}



struct User: Decodable, Equatable {
    
    enum usersKey: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum nameKey: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum pictureKey: String, CodingKey {
            case large
            case medium
            case thumbnail
        }
    }
    
    let title: String
    let first: String
    let last: String
    
    let email: String
    let phone: String
    
    let large: String
    let medium: String
    let thumbnail: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: usersKey.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: usersKey.nameKey.self, forKey: .name)
        self.title = try nameContainer.decode(String.self, forKey: .title)
        self.first = try nameContainer.decode(String.self, forKey: .first)
        self.last = try nameContainer.decode(String.self, forKey: .last)
        
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self forKey: .phone)
        
        let pictureContainer = try container.nestedContainer(keyedBy: usersKey.pictureKey.self, forKey: .picture)
        self.large = try pictureContainer.decode(String.self, forKey: .large)
        self.medium = try pictureContainer.decode(String.self, forKey: .medium)
        self.thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
    }
}

//regular way without using intermediate codable

/*
struct Usersss: Decodable {
    let results: [Userss]
    
    struct Userss: Decodable {
        let name: Names
        
        struct Names: Decodable {
            let title: String
            let first: String
            let last: String
        }
        
        let email: String
        let phone: String
        
        let picture: Pictures
        
        struct Pictures: Decodable {
            let large: String
            let medium: String
            let thumbnail: String
        }
    }
}
*/
