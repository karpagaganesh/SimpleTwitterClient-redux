//
//  User.swift
//  SimpleTwitterClient
//
//  Created by Patchirajan, Karpaga Ganesh on 4/16/17.
//  Copyright © 2017 Patchirajan, Karpaga Ganesh. All rights reserved.
//

import UIKit

class User: NSObject {
    var name : String?
    var screenName : String?
    var profileURL : URL?
    var tagline: String?
    var dictionary: NSDictionary?
    
    init(userDictionary : NSDictionary){
        self.dictionary = userDictionary
        self.name = userDictionary["name"] as? String
        self.screenName = userDictionary["screen_name"] as? String
        if let profileURLString = userDictionary["profile_image_url_https"] as? String {
            let profileURL = URL(string: profileURLString)
            self.profileURL = profileURL
        }
        self.tagline = userDictionary["description"] as? String
        
    }
    
    static var _currentUser : User?
    
    class var currentUser : User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                var userData = defaults.object(forKey: "currentUser") as? Data
                if let userData = userData {
                    let userDictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(userDictionary: userDictionary)
                }
            }
            return _currentUser
        }
        set(user){
            let defaults = UserDefaults.standard
            if let user = user{
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(data, forKey: "currentUser")
            }
            else{
                defaults.set(nil, forKey: "currentUser")
            }
            defaults.synchronize()
        }
    }
}
