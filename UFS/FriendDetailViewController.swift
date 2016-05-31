//
//  FriendDetailViewController.swift
//  UFS
//
//  Created by Митько Евгений on 30.05.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit
import VK_ios_sdk
import SAMCache

class FriendDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var friend: Friend?
    var groups = [Group]()
    var refreshControl = UIRefreshControl()
    
    
    // MARK: - View Flow Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGroupsData()
        setPullToRefresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        refresh()
        
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
        self.view.setNeedsDisplay()
    }
    
    //MARK: - UICollectionView DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! GroupCollectionViewCell
        cell.setCell(groups[indexPath.item], forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = self.view.frame.size.width
        print(screenWidth)
        let numberOfCells: Int
        if screenWidth > 768 {
            numberOfCells = 5
        } else if screenWidth > 414 {
            numberOfCells = 4
        } else if screenWidth > 375 {
            numberOfCells = 3
        } else if screenWidth > 320 {
            numberOfCells = 2
        } else {
            numberOfCells = 1
        }
        let cellHeight: CGFloat = 100
        let padding = 12
        let availableWidth = collectionView.frame.size.width - CGFloat(padding * (numberOfCells - 1))
        let cellWidth = availableWidth / CGFloat(numberOfCells)

        return CGSizeMake(cellWidth, cellHeight)
    }
    
    //MARK: - Helper Methods
  
    func setPullToRefresh() {
        let attributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(FriendsViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    func refresh() {
        let cache = SAMCache.sharedCache()
        cache.removeAllObjects()
        fetchGroupsData()
    }
    
    //MARK: Network Methods
    func fetchGroupsData() {
        guard let passedFriend = friend else {
            return
        }
        let request = Request()
        request.groups(passedFriend.userId) { (responce) in
            self.groups = responce
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.collectionView.userInteractionEnabled = true
            self.navigationItem.title = "\(self.groups.count) groups"
        }

    }
}
