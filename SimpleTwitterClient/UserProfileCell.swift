//
//  UserProfileCell.swift
//  SimpleTwitterClient
//
//  Created by Patchirajan, Karpaga Ganesh on 4/23/17.
//  Copyright © 2017 Patchirajan, Karpaga Ganesh. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {

    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    var user: User! {
        didSet {
            nameLabel.text = user.name
            tweetCountLabel.text = user.statuses_count
            followingCountLabel.text = user.following_count
            followersCountLabel.text = user.followers_count
            if let screenName = user.screenName {
                screenNameLabel.text = "@\(screenName)"
            }
            
            if let profilePicUrl = user.profileURL {
                profilePicImageView.setImageWith(profilePicUrl)
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
