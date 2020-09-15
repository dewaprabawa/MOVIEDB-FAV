//
//  TMDBresponse.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 09/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation


struct TMDBresponse:Codable {
    
        let statusCode: Int
        let statusMessage: String
        
        enum CodingKeys: String, CodingKey {
            case statusCode = "status_code"
            case statusMessage = "status_message"
        }
    }

    extension TMDBresponse: LocalizedError {
        var errorDescription: String? {
            return statusMessage
        }
    }
