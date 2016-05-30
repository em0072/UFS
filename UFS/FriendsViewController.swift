//
//  FriendsViewController.swift
//  UFS
//
//  Created by Митько Евгений on 28.05.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit
import SAMCache
import VK_ios_sdk

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let request = Request()
    var friends = [Friend]()
    var filteredFriends = [Friend]()
    var refreshControl = UIRefreshControl()
    var selectedFriend: Friend?
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearence()
        setPullToRefresh()
        fetchFriendsData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        refresh()
    }
    
    //MARK: Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = self.tableView.contentOffset.y
        for cell in self.tableView.visibleCells as! [FriendTableViewCell] {
            let x = cell.backgroundImage.frame.origin.x
            let w = cell.backgroundImage.bounds.width
            let h = cell.backgroundImage.bounds.height
            let y = (((offsetY) - cell.frame.origin.y) / h) * 25
            cell.backgroundImage.frame = CGRectMake(x, y, w, h)
        }
    }
    
    //MARK: - TableView Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredFriends.count
        } else {
            return friends.count
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FriendTableViewCell
        if isSearching {
            cell.setCell(filteredFriends[indexPath.row], withIndexPath: indexPath)
        } else {
            cell.setCell(friends[indexPath.row], withIndexPath: indexPath)
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isSearching {
            selectedFriend = filteredFriends[indexPath.row]
        } else {
            selectedFriend = friends[indexPath.row]
        }
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: false)
        self.performSegueWithIdentifier("showDetails", sender: self)
    }
    
   //MARK: - Search Bar Delegate
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            if searchText.isEmpty {
                self.isSearching = false
                print("Search Off")
            } else {
                self.isSearching = true
                self.filteredFriends = self.friends.filter({(friend: Friend) -> Bool in
                    if friend.searchString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                        return true
                    } else {
                        return false
                    }
                })
                if self.filteredFriends.count == 0 {
                    let noData = Friend()
                    noData.city = "No search results=(("
                    noData.universityName = ""
                    self.filteredFriends.append(noData)
                }
        }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
        }
    }
    
    //MARK: - Segue Methods
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
            let vc = segue.destinationViewController as! FriendDetailViewController
            if let friendToPass = selectedFriend {
                vc.friend = friendToPass
            }
        }
    }
    
    
    //MARK: - Helper Methods
    
    func setAppearence() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Logout", style: .Done, target: self, action: #selector(FriendsViewController.logout))
        let redColor = UIColor(red: 175/255, green: 64/255, blue: 52/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = redColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        searchBar.tintColor = redColor
        searchBar.barTintColor = redColor
    }
    
    func setPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(FriendsViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refresh() {
        let cache = SAMCache.sharedCache()
        cache.removeAllObjects()
        fetchFriendsData()
    }
    
    func logout() {
        VKSdk.forceLogout()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: Network Methods
    func fetchFriendsData() {
        request.friends { (friends) in
            self.friends = friends
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.tableView.userInteractionEnabled = true
        }
    }
    
    //MARK: Search Methods
    func filterContentForSearchText(searchText: String, scope:String = "All") {
        filteredFriends = friends.filter({(friend: Friend) -> Bool in
            let categoryMatch = (scope == "All")
            let stringMatch = friend.firstName?.rangeOfString(searchText)
            
            return categoryMatch && (stringMatch != nil)
        })
    }

}
