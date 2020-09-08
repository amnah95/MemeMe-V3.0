//
//  Response.swift
//  MemeMe-V3.0
//
//  Created by Amnah on 9/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


    
struct Response: Codable {
    let success: Bool
    let data: Meme
}

extension Response: LocalizedError {
    var errorDescription: String? {
        return "Network request status is: \(success)"
    }
}
