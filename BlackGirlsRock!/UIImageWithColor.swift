//
//  UIImageWithColor.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/18/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

extension UIImage
{
    class func createWith(color:UIColor)->UIImage
    {
        UIGraphicsBeginImageContext(CGSize(width: 1,height: 1))
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, CGRect(x: 0, y: 0, width: 1, height: 1));
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image;
        
    }
    
    func imageWithColor(color:UIColor)->UIImage
    {
        UIGraphicsBeginImageContext(self.size);
        let contect = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(contect, 1, -1);
        CGContextTranslateCTM(contect, 0, -self.size.height);
        CGContextClipToMask(contect, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
        CGContextSetFillColorWithColor(contect, color.CGColor);
        CGContextFillRect(contect, CGRectMake(0, 0, self.size.width, self.size.height));
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;

    }
}
