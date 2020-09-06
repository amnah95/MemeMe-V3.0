//
//  MemesLibrary.swift
//  MemeMe-V3.0
//
//  Created by Amnah on 9/03/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

class MemesLibrary {
    
    static let shared = MemesLibrary()
    
    private init(){}
    
    var memes = [Meme]()
    
}
