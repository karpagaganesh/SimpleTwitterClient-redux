//
//  TweetViewController.swift
//  SimpleTwitterClient
//
//  Created by Patchirajan, Karpaga Ganesh on 4/16/17.
//  Copyright © 2017 Patchirajan, Karpaga Ganesh. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var twitterText: UILabel!
    @IBOutlet weak var createdTimeStamp: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var additionalDetailTableView: UITableView!
    
    var nameStr: String?
    var twitterHandleString: String?
    var twitterTextFieldString: String?
    var userImageURL: URL?
    var createdTimeStampString: Date?
    var reTweetCount: Int?
    var favouritesCount: Int?
    
    var tweet: Tweet!
    
    @IBAction func backToTweetsView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalDetailTableView.dataSource = self
        additionalDetailTableView.delegate = self
        
        name.text = nameStr
        twitterHandle.text = twitterHandleString
        twitterText.text = twitterTextFieldString
        userImage.setImageWith(userImageURL!)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/dd/yyyy, h:mm a"
        var dateString = dateFormatter.string(from: createdTimeStampString!)

        createdTimeStamp.text = dateString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatNumberCell", for: indexPath) as! StatNumberCell;
            cell.favouritesCountLabel.text = String(describing: favouritesCount!)
            cell.retweetCountLabel.text = String(describing: reTweetCount!)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetSymbolCell", for:
                indexPath) as! TweetSymbolCell;
            return cell
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
