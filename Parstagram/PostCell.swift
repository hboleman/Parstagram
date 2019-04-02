//
//  PostCell.swift
//  Parstagram
//
//  Created by Hunter Boleman on 3/23/19.
//  Copyright © 2019 Hunter Boleman. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    //-------------------- Class Setup --------------------//
    
    // Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var captionLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
