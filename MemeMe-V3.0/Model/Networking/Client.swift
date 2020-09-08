//
//  Client.swift
//  MemeMe-V3.0
//
//  Created by Amnah on 9/7/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class Client {
    
    enum EndPoints: String {
        
        static let base = "https://api.imgflip.com/"
        
        case getMemes
        
        var stringValue: String {
            switch self {
            case .getMemes:
                return EndPoints.base + "get_memes"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //This is a genreal get request, it either returns a responseObject or an error
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
                        
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(Response.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }

    
    //Get memes
    static func getMemes(completion: @escaping ([MemeData], Error?) -> Void) {
                
        _ = taskForGETRequest(url: EndPoints.getMemes.url , responseType: Response.self) { response, error in
            if let response = response {
                print("task completed")
                print(response)
                completion(response.data.memes, nil)
            } else {
                print("task did not run")
                completion([], error)
            }
        }
    }
    
    
    // Load image using its URL
    class func requestImageFile(_ url : URL, completion: @escaping (Data?,Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else
            {
                print("no data were obtaind for photo")
                completion(nil, error)
                return
            }
            print("photo data from link: \(url)")
            print(data)

            completion(data, nil)
        }
        task.resume()
    }

    
}


