//
//  Parser.swift
//  UFS
//
//  Created by Митько Евгений on 29.05.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit

class Parser {
    
    func makeFriendObject(friendDict: [String:AnyObject]) -> Friend? {
        let friend = Friend()
        if let userId = friendDict["id"] as? Int {
            friend.userId = userId
        }
        if let firstName = friendDict[FIRST_NAME] as? String {
            friend.firstName = firstName
            friend.searchString += firstName
        }
        if let lastName = friendDict[LAST_NAME] as? String {
            friend.lastName = lastName
            friend.searchString += lastName
        }
        if let city = friendDict[CITY]?[CITY_TITLE] as? String {
            friend.city = city
            friend.searchString += city
        }
        if let universityName = friendDict[UNIVERSITY_NAME] as? String {
            friend.universityName = universityName
            friend.searchString += universityName
        }
        if let photoPath = friendDict[BIG_PHOTO] as? String {
            friend.photoPath = photoPath
        } else if let photoPath = friendDict[SMALL_PHOTO] as? String {
            friend.photoPath = photoPath
        }
        
        return friend
        
        
    }
    
    func composeFriendsFromJSON(json: AnyObject) -> [Friend]? {
        var friends = [Friend]()
        guard let jsonFullDict = json as? [String:AnyObject] else {
            print("jsonFullDict is broken")
            return nil
        }
        guard let jsonFriendsDict = jsonFullDict["items"] as? [[String:AnyObject]] else {
            print("jsonFriendsDict is broken")
            return nil
        }
//        print(jsonFriendsDict)
        for item in jsonFriendsDict {
            if let friend = makeFriendObject(item) {
                friends.append(friend)
            }
        }
        return friends
    }
    
    func makeGroupObject(groupDict: [String:AnyObject]) -> Group? {
        let group = Group()
        if let id = groupDict["id"] as? Int {
            group.id = id
        }
        if let name = groupDict["name"] as? String {
            group.name = name
        }
        if let screenName = groupDict["screen_name"] as? String {
            group.screenName = screenName
        }
        if let type = groupDict["type"] as? String {
            group.type = type
        }
        if let photoPath = groupDict[BIG_PHOTO] as? String {
            group.photoPath = photoPath
        } else if let photoPath = groupDict[SMALL_PHOTO] as? String {
            group.photoPath = photoPath
        }
        
        return group
        
        
    }
    
    func composeGroupsFromJSON(json: AnyObject) -> [Group]? {
        var groups = [Group]()
        guard let jsonFullDict = json as? [String:AnyObject] else {
            print("jsonFullDict is broken")
            return nil
        }
        guard let jsonGroupsDict = jsonFullDict["items"] as? [[String:AnyObject]] else {
            print("jsonFriendsDict is broken")
            return nil
        }
        //        print(jsonFriendsDict)
        for item in jsonGroupsDict {
            if let group = makeGroupObject(item) {
                groups.append(group)
            }
        }
        return groups
    }

}
