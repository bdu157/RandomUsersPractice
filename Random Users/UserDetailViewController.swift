//
//  UserDetailTableViewController.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserDetailTableViewController: UIViewController {

    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    var cache: Cache<String, Data>?
    var usersController: UsersController?
    var user: User? {
        didSet {
            self.updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
 
    private func updateViews() {
        if let usersController = usersController,
            let user = user {
        let title = user.title.capitalized
        let first = user.first.capitalized
        let last = user.last.capitalized
        self.fullNameLabel.text = "\(title) \(first) \(last)"
        self.phoneNumberLabel.text = user.phone
        self.emailAddressLabel.text = user.email
        
        //fetchingLarge image based on user and usersController and load the image in main queue
            usersController.fetchThumbnailAndLarge(for: user.large) { (result) in
                if let result = try? result.get() {
                    DispatchQueue.main.async {
                        let image = UIImage(data: result)
                        self.largeImage.image = image
                    }
                    guard let passedCache = self.cache else {return}
                    passedCache.cache(value: result, for: user.email)
                }
            }
        }
    }

}
