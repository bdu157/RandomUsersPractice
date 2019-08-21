//
//  UsersController.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case otherError
    case noData
}

class UsersController {
    var users: [User] = []
    
    var baseURL = URL(string: "https://randomuser.me/api/")!
    //https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000
    func getUsers(forNum numberOfResults: Int = 2000, completion: @escaping (Error?)->Void) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let formatQueryItem = URLQueryItem(name: "format", value: "json")
        let incQueryItem = URLQueryItem(name: "inc", value: "name,email,phone,picture")
        let resultsQueryItem = URLQueryItem(name: "results", value: String(numberOfResults))
        urlComponents?.queryItems = [formatQueryItem, incQueryItem, resultsQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            NSLog("there is no URL")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("there is an error in getting data: \(error)")
                completion(NSError())
                return
            }
            
            guard let data = data else {
                NSLog("there is an error : no data")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let userDatas = try jsonDecoder.decode(Users.self, from: data)
                let userData = userDatas.results
                self.users = userData
                //print(self.users)
                completion(nil)
            } catch {
                NSLog("unable to complete decdoing: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    func fetchThumbnailAndLarge(for urlString: String, completion: @escaping (Result<Data, NetworkError>)->Void) {
        let imageURL = URL(string: urlString)!
        
        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("there is an error in getting data: \(error)")
                completion(.failure(.otherError))
                return
            }
            guard let data = data else {
                NSLog("there is an error getting data")
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
