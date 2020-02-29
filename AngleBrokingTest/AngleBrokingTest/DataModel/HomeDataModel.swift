//
//  HomeDataModel.swift
//  AngleBrokingTest
//
//  Created by A1Technology on 2/29/20.
//  Copyright © 2020 vinit.somani. All rights reserved.
//

import Foundation

struct HomeDataModel: Codable {
    var users         : [User]?
    var ok            : Bool?
    
    enum CodingKeys: String, CodingKey {
        case ok = "ok"
        case users = "users"
    }
    
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            ok = try values.decodeIfPresent(Bool.self, forKey: .ok)
            users = try values.decodeIfPresent([User].self, forKey: .users)
        }
        catch {
            print(error)
        }

    }
}


struct User: Codable {

    var avatar_url                  : String?
    var display_name                : String?
    var id                          : Int?
    var username                    : String?
    
    enum CodingKeys: String, CodingKey {
         case id                  = "id"
         case avatar_url          = "avatar_url"
         case display_name        = "display_name"
         case username            = "username"
    }
    

    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            avatar_url = try values.decodeIfPresent(String.self, forKey: .avatar_url)
            display_name = try values.decodeIfPresent(String.self, forKey: .display_name)
            username = try values.decodeIfPresent(String.self, forKey: .username)
        } catch {
            print(error)
        }
    }
}
