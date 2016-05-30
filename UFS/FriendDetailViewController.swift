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

class FriendDetailViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var friend: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGroupsData()
    }
    
    func fetchGroupsData() {
        guard let passedFriend = friend else {
            return
        }
        label.text = passedFriend.firstName!
        let request = Request()
        request.groups(passedFriend.userId) { (responce) in
            print(responce)
            print(responce.count)
        }

    }
}
