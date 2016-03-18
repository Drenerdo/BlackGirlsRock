//
//  Keyboardbehaviourextention.swift
//  BlackGirlsRock!
//
//  Created by Aleksandr Budnik on 18.03.16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit
private var curTextfieldAssociationKey: UInt8 = 0
private var curViewAssociationKey: UInt8 = 0

extension UIViewController {
    var curtextfield: UITextField? {
            get {
                    return objc_getAssociatedObject(self, &curTextfieldAssociationKey) as? UITextField
        }
                set(newValue) {
                    objc_setAssociatedObject(self, &curTextfieldAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var extensionScrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &curViewAssociationKey) as? UIScrollView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &curViewAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }


func keyboardRegister (){
    
    //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardShows:"), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardShows:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardHides"), name: UIKeyboardWillHideNotification, object: nil)

}
func keyboardUnreigster (){
    NSNotificationCenter.defaultCenter().removeObserver(self)
}

func keyboardShows (notification:NSNotification) {
   

    let keyboard:CGRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
    let textField:CGRect = self.curtextfield!.convertRect(self.curtextfield!.bounds, toView:nil)
    let diff = CGRectGetMaxY(textField) - keyboard.origin.y
    print("\(keyboard) \(textField)")
    if (diff>0)
    {
        
        
        var point = extensionScrollView!.contentOffset;
        point.y+=diff;
        extensionScrollView?.contentOffset = point
    }
    
    extensionScrollView!.contentInset = UIEdgeInsets (top: 0,left: 0,bottom: keyboard.height,right: 0);
    
};
func keyboardHides () {
    
  extensionScrollView!.contentInset = UIEdgeInsets (top: 0,left: 0,bottom: 0,right: 0);
};
}