//
//  TwitterRestClient.swift
//  SimpleTwitterClient
//
//  Created by Patchirajan, Karpaga Ganesh on 4/16/17.
//  Copyright © 2017 Patchirajan, Karpaga Ganesh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterRestClient: BDBOAuth1SessionManager {
    
    static let singletonInstance = TwitterRestClient(baseURL: URL(string: Constants.TWITTER_API_BASE)!, consumerKey:"VghTOrO51Lr23CIcwZTgNAzaV",consumerSecret:"x9IlA7FImUPxZY9GuTUufca5Rkj0cMvYMWJ4kBYq82yG7jKjiV")!
    

    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success:@escaping () -> (), failure: @escaping (Error) -> ()) -> Void {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: Constants.OAUTH_REQUEST_TOKEN,
                                        method: Constants.GET,
                                        callbackURL: URL(string: "twitterdemo://oauth")!,
                                        scope: nil,
                                        success: { (requestToken: BDBOAuth1Credential!) -> Void in
                                            let authTokenURL = Constants.TWITTER_API_BASE + "/oauth/authorize?oauth_token=\(requestToken.token!)"
                                            
                                            let url = URL(string : authTokenURL)!
                                            UIApplication.shared.openURL(url)
                                            
        }, failure: { (error: Error!) -> Void in
            self.loginFailure!(error)
        })
    }
    
    func logout() -> Void {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }
    
    func handleOpenUrl (url: URL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: Constants.OAUTH_ACCESS_TOKEN, method: Constants.POST, requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.verifyCredentials(success: { (currentUSer: User) in
                User.currentUser = currentUSer
                self.loginSuccess?()
            }, failure: { (error: Error) in
                print (error.localizedDescription)
            })
        }, failure: { (error: Error!) -> Void in
            self.loginFailure?(error)
        })

    }
    
    func verifyCredentials(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) -> Void {
        get(Constants.API_VERIFY_CREDENTIALS, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any) -> Void in
            let user = User(userDictionary: response as! NSDictionary)
            success(user)
        }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func retreiveHomeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> () ) -> Void {
        get(Constants.API_HOME_TIMELINE, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any) -> Void in
            let tweets = Tweet.retrieveTweets(dictionaries: response as! [NSDictionary])
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func postTweet(status : String, success : @escaping (Tweet) -> (), failure : @escaping (Error) -> ()) {
        verifyCredentials(success: { (user: User) in
            
            let params = ["status" : status]
            
            self.post(Constants.API_POST_STATUS, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any) -> Void in
                if let dictionary = response as? NSDictionary {
                    let tweet = Tweet(tweetDictionary: dictionary);
                    success(tweet)
                }
            }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
                failure(error)
            })
            
        }) { (error: Error) in
            failure(error)
        }
        
    }
}
