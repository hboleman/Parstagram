//
//  PostCell.swift
//  Parstagram
//
//  Created by Hunter Boleman on 3/23/19.
//  Copyright © 2019 Hunter Boleman. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var captionLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
