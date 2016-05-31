//
//  Service.swift
//  UFS
//
//  Created by Митько Евгений on 31.05.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit

class Service: UIViewController {
    
    func showAlertWithText(text:String, on viewController: UIViewController) {
        
        if (NSClassFromString("UIAlertController") != nil) {
            print("UIAlertController can be instantiated")
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: "Alert", message: text, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                }
                alert.addAction(okAction)
                viewController.presentViewController(alert, animated: true) {
                }
            }
        }
        else {
            print("UIAlertController can NOT be instantiated")
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = text
            alert.addButtonWithTitle("OK")
            alert.show()
        }

           }
    
    
}