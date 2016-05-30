//
//  FriendTableViewCell.swift
//  UFS
//
//  Created by Митько Евгений on 29.05.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit
import SAMCache

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var wrappedView: UIView!
    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var universityNameLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let cache = SAMCache.sharedCache()

    func setCell(friendData: Friend, withIndexPath indePath: NSIndexPath) {
        if let firstName = friendData.firstName {
            firstNameLabel.text = firstName
        } else {
            firstNameLabel.text = ""
        }
        if let lastName = friendData.lastName {
            lastNameLabel.text = lastName
        } else {
            lastNameLabel.text = ""
        }
        if let city = friendData.city {
            cityLabel.text = city
        } else {
            cityLabel.text = "Ooops! No city data=("
        }
        if let universityName = friendData.universityName {
            universityNameLabel.text = universityName
        } else {
            universityNameLabel.text = "Ooops! No university data=("
        }
        self.tag = indePath.row
        userPicImageView.layer.cornerRadius = userPicImageView.bounds.size.width / 2
        userPicImageView.layer.masksToBounds = true
        userPicImageView.image = nil
        backgroundImage.image = nil
        if let photoPath = friendData.photoPath {
            loadPhoto(photoPath, withIndexPath: indePath)
        }
    }
    
    func loadPhoto(photoPath: String, withIndexPath indePath: NSIndexPath) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            var image = UIImage()
            if let cachedImage = self.cache.imageForKey(photoPath) {
                image = cachedImage
            } else {
                let url = NSURL(string: photoPath)
                if let photoData = NSData(contentsOfURL: url!) {
                    image = UIImage(data: photoData)!
                    self.cache.setImage(image, forKey: photoPath)
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                if self.tag == indePath.row {
                    self.userPicImageView.image = image
                    self.backgroundImage.image = image
                    
                }
            })
            
        }
    }
    
}
