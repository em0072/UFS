//
//  Request.swift
//  UFS
//
//  Created by Митько Евгений on 28.05.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit
import VK_ios_sdk




class Request {
    
    let parser = Parser()
    
    func  friends(completion: ([Friend]) -> ()) {
        let fields = "\(USER_ID), \(FIRST_NAME), \(LAST_NAME), \(BIG_PHOTO), \(SMALL_PHOTO), \(CITY), \(EDUCATION)"
        let request: VKRequest = VKApi.friends().get([VK_API_FIELDS : fields])
        request.executeWithResultBlock({ (responce) in
            if let friends = self.parser.composeFriendsFromJSON(responce.json) {
                completion(friends)
            }
        }) { (error) in
            print(error.debugDescription)
        }
    }
    
    func groups(userId: Int, completion: ([Group]) -> ()) {
        let request: VKRequest = VKApi.requestWithMethod("groups.get", andParameters: [VK_API_USER_ID: 2144227, "extended" : 1])
        request.executeWithResultBlock({ (responce) in
            if let group = self.parser.composeGroupsFromJSON(responce.json) {
                completion(group)
            }
            }) { (error) in
                print(error.debugDescription)
        }
        
        
    }
    
}
