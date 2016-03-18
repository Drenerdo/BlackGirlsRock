//
//  GradientView.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/18/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib();
        let layer = self.layer as! CAGradientLayer;
        layer.colors = [UIColor(red: 70.0/255.0, green: 22.0/255.0, blue: 107.0/255.0, alpha: 1.0).CGColor,UIColor(red: 116.0/255.0, green: 27.0/255.0, blue: 121.0/255.0, alpha: 1.0).CGColor];
        layer.locations = [0,1];
        layer.startPoint = CGPoint(x: 0.5,y: 0);
        layer.endPoint = CGPoint(x: 0.5,y: 1);
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self;
    }

}
