//
//  PlayListCell.swift
//  BlackGirlsRock!
//
//  Created by Sergey on 3/28/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

class PlayListCell: UITableViewCell {

    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet var songImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.songImage.layer.cornerRadius = self.songImage.frame.size.width/2.0
        self.songImage.clipsToBounds = true;
        self.songImage.setShowActivityIndicatorView(true);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
