//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    var imageData: Data?
    var dataTask: URLSessionDataTask?
    
    override func start() {
        state = .isExecuting
        
        let request = URL(string: self.thumbnail)
        
        let task = URLSession.shared.dataTask(with: request!) { (data, _, error) in
            if self.isCancelled {return}
            
            if let error = error {
                NSLog("there is an error in getting data")
                return
            }
            
            defer {self.state = .isFinished}
            self.imageData = data
        }
        task.resume()
        self.dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
    
    let title: String
    let first: String
    let last: String
    
    let email: String
    let phone: String
    
    let large: String
    let medium: String
    let thumbnail: String
    
    init(user: User) {
        self.title = user.title
        self.first = user.first
        self.last = user.last
        self.email = user.email
        self.phone = user.phone
        self.large = user.large
        self.medium = user.medium
        self.thumbnail = user.thumbnail
    }
}
