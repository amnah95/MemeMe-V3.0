//
//  MemesLibrary.swift
//  MemeMe-V2.0
//
//  Created by Amnah on 6/18/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

class MemesLibrary {
    
    static let shared = MemesLibrary()
    
    private init(){}
    
    var memes = [Meme]()
    
}
