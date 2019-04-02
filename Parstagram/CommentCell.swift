//
//  CommentCell.swift
//  Parstagram
//
//  Created by Hunter Boleman on 4/1/19.
//  Copyright © 2019 Hunter Boleman. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    //-------------------- Class Setup --------------------//
    
    // Outlets
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var commentLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
