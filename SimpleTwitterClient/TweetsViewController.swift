//
//  TweetsViewController.swift
//  SimpleTwitterClient
//
//  Created by Patchirajan, Karpaga Ganesh on 4/16/17.
//  Copyright © 2017 Patchirajan, Karpaga Ganesh. All rights reserved.
//

import UIKit
import AFNetworking
import KVLoading

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tweetsTableView: UITableView!
    var twitterRestClient = TwitterRestClient.singletonInstance
    var tweets = [Tweet]()
    let refreshControl = UIRefreshControl();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged);
        
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        
        requestNewTweets()
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshControlAction(_ refreshControl: UIRefreshControl) {
        requestNewTweets()
    }
    
    func requestNewTweets() {
        KVLoading.show()
        twitterRestClient.retreiveHomeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = [Tweet]()
            for tweet in tweets {
                self.tweets.append(tweet)
            }
            
            self.tweetsTableView.reloadData()
            self.refreshControl.endRefreshing();
            
        }) { (error: Error) in
            print (error.localizedDescription)
            self.refreshControl.endRefreshing();
        }
        KVLoading.hide()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print (segue.identifier)
        if("tweetViewSegue" == segue.identifier!){
            let tweetViewController = segue.destination as! TweetViewController
            let indexPath = tweetsTableView.indexPath(for: sender as! UITableViewCell)!
            let tweet = self.tweets[indexPath.row]
            let user = tweet.user
            tweetViewController.twitterTextFieldString = tweet.text!
            tweetViewController.createdTimeStampString = tweet.createdTimeStamp!
            
            tweetViewController.nameStr = user?.name
            tweetViewController.twitterHandleString = "@"+(user?.screenName)!
            tweetViewController.userImageURL = (user?.profileURL)!
            tweetViewController.favouritesCount = tweet.favouritesCount
            tweetViewController.reTweetCount = tweet.reTweetCount
        }
        else if("newTweetSegue" == segue.identifier!){
            let newTweetController = segue.destination as! NewTweetViewController
            var currentUser = User.currentUser
            var name = currentUser?.name!
            var twitterHandle = currentUser?.screenName!
            var profileURL = currentUser?.profileURL!
            
            newTweetController.nameStr = name
            newTweetController.twitterHandleString = twitterHandle
            newTweetController.userImageURL = profileURL
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.tweets.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell;
        let tweet = self.tweets[indexPath.row]
        let user = tweet.user
        cell.tweetText.text = tweet.text!
        cell.name.text = user?.name
        cell.twitterHandleName.text = "@"+(user?.screenName)!
        cell.userImage.setImageWith((user?.profileURL)!)
        return cell;
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterRestClient.singletonInstance.logout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
