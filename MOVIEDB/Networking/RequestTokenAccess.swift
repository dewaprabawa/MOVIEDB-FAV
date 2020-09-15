//
//  RequestTokenAccess.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 09/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation

struct RequestTokenAccess:Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
