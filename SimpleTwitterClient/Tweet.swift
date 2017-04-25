//
//  Tweet.swift
//  SimpleTwitterClient
//
//  Created by Patchirajan, Karpaga Ganesh on 4/16/17.
//  Copyright © 2017 Patchirajan, Karpaga Ganesh. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var createdTimeStamp: Date?
    var reTweetCount: Int = 0
    var favouritesCount: Int = 0
    var user: User?
    
    init(tweetDictionary: NSDictionary){
        self.text = tweetDictionary["text"] as? String
        self.reTweetCount = (tweetDictionary["retweet_count"] as? Int) ?? 0
        self.favouritesCount = (tweetDictionary["favourites_count"] as? Int) ?? 0
        let userDictionary = tweetDictionary["user"] as? NSDictionary
        
        if let userDictionary = userDictionary {
            let user = User(userDictionary: userDictionary)
            self.user = user
        }
        if let createdTimeStampString = tweetDictionary["created_at"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            self.createdTimeStamp = dateFormatter.date(from: createdTimeStampString)
        }
    }
    
    class func retrieveTweets(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries{
            let tweet = Tweet(tweetDictionary: dictionary)
            tweets.append(tweet)
            
        }
        return tweets
    }
    
}
