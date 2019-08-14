//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UsersTableViewController: UITableViewController {
    
    var usersController = UsersController()
    var cache = Cache<String, Data>()
    private var operations = [String : Operation]()
    private var photoFetchQueue = OperationQueue()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersController.getUsers{ (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersController.users.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        guard let customCell = cell as? UsersTableViewCell else {return UITableViewCell() }
        let user = self.usersController.users[indexPath.row]
        customCell.user = user
        self.loadImage(forCell: customCell, forRowAt: indexPath)
        return cell
    }
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = usersController.users[indexPath.row]
        
        operations[user.email]?.cancel()
        print("cancelling is happening")
    }
    
    
    private func loadImage(forCell cell: UsersTableViewCell, forRowAt indexPath: IndexPath) {
        let user = usersController.users[indexPath.row]
        
        
        let fetchPhotoOperation = FetchPhotoOperation(user: user)
        
        let cachedOperation = BlockOperation {
            if let data = fetchPhotoOperation.imageData {
                self.cache.cache(value: data, for: fetchPhotoOperation.email)
            }
        }
        
        let checkReuseOperation = BlockOperation {
            //defer {self.operations.removeValue(forKey: user.email)}
            
            if let currentIndexPath = self.tableView.indexPath(for: cell),
                currentIndexPath != indexPath {
                return
            } else {
                if let cachedValue = self.cache.value(for: user.email) {
                    let image = UIImage(data: cachedValue)
                    cell.thumbnailImage.image = image
                } else {
                    if let data = fetchPhotoOperation.imageData {
                        let image = UIImage(data: data)
                        cell.thumbnailImage.image = image
                    }
                }
            }
        }
        
        cachedOperation.addDependency(fetchPhotoOperation)
        checkReuseOperation.addDependency(fetchPhotoOperation)
        
        photoFetchQueue.addOperation(fetchPhotoOperation)
        photoFetchQueue.addOperation(cachedOperation)
        
        //checkResueOperation should run in main queue since it will update UI - cell.thumbnailimage
        OperationQueue.main.addOperation(checkReuseOperation)
        
        //self.operations[user.email] = fetchPhotoOperation
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailVC" {
            guard let destVC = segue.destination as? UserDetailTableViewController,
                let selectedRow = self.tableView.indexPathForSelectedRow else {return}
                destVC.user = self.usersController.users[selectedRow.row]
                destVC.usersController = self.usersController
        }
    }

}
