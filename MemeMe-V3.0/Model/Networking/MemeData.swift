//
//  MemeData.swift
//  MemeMe-V3.0
//
//  Created by Amnah on 9/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation


struct Meme: Codable {
    let memes: [MemeData]
}


struct MemeData: Codable {
    let id: String
    let name: String
    let url: String
    let width: Int
    let height: Int
    let box_count: Int
    
    
    func memeURL() -> URL {
        return URL(string: url)!
    }
}


