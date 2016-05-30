//
//  ViewController.swift
//  UFS
//
//  Created by Митько Евгений on 28.05.16.
//  Copyright © 2016 Evgeny Mitko. All rights reserved.
//

import UIKit
import VK_ios_sdk

class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let SCOPE = [VK_PER_FRIENDS, VK_PER_GROUPS]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initializeVK()
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        if (result.token != nil)  {
            print("vkSdk Access Authorization Finished With Result User")
            showFriendsTableView(true)
        } else if (result.error != nil) {
            print("vkSdk Access Authorization Finished With Result error")
        }
    }
    
    /**
     Notifies about access error. For example, this may occurs when user rejected app permissions through VK.com
     */
    func vkSdkUserAuthorizationFailed() {
        
    }
    
    func vkSdkNeedCaptchaEnter(captchaError: VKError!) {
        
    }
    
    func vkSdkShouldPresentViewController(controller: UIViewController!) {
        self.presentViewController(controller, animated: true) { 
            print("done presenting VC")
        }
    }
    
    
    func  showFriendsTableView(animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("friendsList")
        self.navigationController?.pushViewController(vc, animated: animated)
    }


    @IBAction func AuthorizationButtonTapped(sender: AnyObject) {
        VKSdk.authorize(SCOPE)
    }
    
    func initializeVK() {
        VKSdk.initializeWithAppId("5483000").registerDelegate(self)
        VKSdk.instance().uiDelegate = self
        VKSdk.wakeUpSession(SCOPE) { (state, error) in
            if state == .Initialized {
                print("Initialized")
                self.statusLabel.text = "Предлагаем Вам авторизироваться с помощь VK.COM"
                self.activityIndicator.stopAnimating()
                self.loginButton.hidden = false
            } else if state == .Authorized {
                print("Authorized")
                self.statusLabel.text = "Предлагаем Вам авторизироваться с помощь VK.COM"
                print("User is logged? \(VKSdk.isLoggedIn())")
                self.showFriendsTableView(true)
            } else if state == .Error {
                print("Error")
            } else {
                print("Else VKAuthorisationState")
            }
        }

    }
}

