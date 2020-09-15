//
//  PostSession.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 09/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation

struct PostSession: Codable {
    
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
    
}

