//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    let usersController = UsersController()
    var user : User? {
        didSet {
            self.updateViews()
        }
    }

    
    private func updateViews() {
        if let user = user {
            let title = user.title.capitalized
            let first = user.first.capitalized
            let last = user.last.capitalized
            self.fullNameLabel.text = "\(title) \(first) \(last)"
            //fetchthumbnail for now
//            self.usersController.fetchThumbnailAndLarge(for: user.thumbnail) { (result) in
//                if let result = try? result.get() {
//                    DispatchQueue.main.async {
//                        let image = UIImage(data: result)
//                        self.thumbnailImage.image = image
//                    }
//                }
//            }
        }
    }
}
