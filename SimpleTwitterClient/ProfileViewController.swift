import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets = [Tweet]()
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        user = User.currentUser
        loadUserTweets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! UserProfileCell
            profileCell.user = user
            return profileCell
        } else {
            let tweetCell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
            
            var tweet = tweets[indexPath.row - 1]
            tweetCell.name.text = tweet.user?.name
            tweetCell.tweetText.text = tweet.text
            tweetCell.twitterHandleName.text = tweet.user?.screenName
            tweetCell.userImage.setImageWith((tweet.user?.profileURL)!)
            return tweetCell
        }
    }
    
    func loadUserTweets() {
        TwitterRestClient.singletonInstance.retreiveHomeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView?.reloadData()
            
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let navigationController = segue.destination as! UINavigationController
        if segue.identifier == "tweetViewSegue" {
            let detailTweetViewController = navigationController.topViewController as! TweetViewController
            detailTweetViewController.tweet = sender as! Tweet
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.row]
        performSegue(withIdentifier: "tweetViewSegue", sender: tweet)
    }
    
    @IBAction func onLogoutButton(_ sender: UIBarButtonItem) {
        TwitterRestClient.singletonInstance.logout()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
