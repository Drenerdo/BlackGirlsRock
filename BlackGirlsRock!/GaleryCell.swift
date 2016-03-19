//
//  GaleryCell.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/19/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

class GaleryCell: UITableViewCell {

    @IBOutlet var imagePreview: UIImageView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class PhotoCollectionCell:UICollectionViewCell
{
    @IBOutlet var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
