//
//  UserDetailTableViewController.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailTableViewController: UIViewController {

    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
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
        guard let usersController = usersController,
            let user = user else {return}
        let title = user.title.capitalized
        let first = user.first.capitalized
        let last = user.last.capitalized
        self.fullNameLabel.text = "\(title) \(first) \(last)"
        self.phoneNumberLabel.text = user.phone
        self.emailAddressLabel.text = user.email
        
        //fetchingLarge image based on user and usersController and load the image in main queue
    }

}
