//
//  GroupCollectionViewCell.swift
//  UFS
//
//  Created by Митько Евгений on 30.05.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit
import SAMCache


class GroupCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    let cache = SAMCache.sharedCache()
    
    func setCell(group:Group, forIndexPath indexPath: NSIndexPath) {
        if let title = group.name {
            titleLabel.text = title
        }
        backgroundImage.image = nil
        self.tag = indexPath.item
        if let photoPath = group.photoPath {
            loadPhoto(photoPath, withIndexPath: indexPath)
        }
    }
    
    func loadPhoto(photoPath: String, withIndexPath indePath: NSIndexPath) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
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
                if self.tag == indePath.item {
                    self.backgroundImage.image = image
                    
                }
            })
            
        }
    }
    
   


    
}
