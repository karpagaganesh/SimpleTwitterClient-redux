//
//  NewTweetViewController.swift
//  SimpleTwitterClient
//
//  Created by Patchirajan, Karpaga Ganesh on 4/18/17.
//  Copyright © 2017 Patchirajan, Karpaga Ganesh. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var nameStr: String?
    var twitterHandleString: String?
    var twitterTextFieldString: String?
    var userImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = nameStr
        twitterHandle.text = twitterHandleString
        userImage.setImageWith(userImageURL!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelNewTweet(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func postTweet(_ sender: Any) {
        var trimmedString = tweetText.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if(!trimmedString.isEmpty)
        {
            TwitterRestClient.singletonInstance.postTweet(status: trimmedString, success: { (tweet: Tweet) in
                print (tweet.text)
            }, failure: { (error: Error) in
                print (error.localizedDescription)
            })
        }

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
