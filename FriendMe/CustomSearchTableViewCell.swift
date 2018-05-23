//
//  CustomSearchTableViewCell.swift
//  FriendHub
//
//  Created by Ryan Schefske on 3/1/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//

import UIKit

class CustomSearchTableViewCell: UITableViewCell {

    // Search table cell outlets
    @IBOutlet var cellView: UIView!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var profileLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
