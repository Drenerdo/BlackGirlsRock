//
//  Kayboardbehaviourextention.swift
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
    
    var curView: UIView? {
        get {
            return objc_getAssociatedObject(self, &curViewAssociationKey) as? UITextField
        }
        set(newValue) {
            objc_setAssociatedObject(self, &curViewAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }


func keyboardRegister (){

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShows", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHides", name: UIKeyboardWillShowNotification, object: nil)

}
func keyboardUnreigster (){
    NSNotificationCenter.defaultCenter().removeObserver(self)
}

func keyboardShows (notification:NSNotification) {
   

    let keyboard:CGRect = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"]!.CGRectValue
    let textField:CGRect = self.view.convertRect(self.curtextfield!.frame, toView:nil)
    if (keyboard.origin.y<CGRectGetMaxY(textField))
    {
        let delta:CGFloat = keyboard.origin.y-CGRectGetMaxY(textField);
        self.view.transform = CGAffineTransformMakeTranslation(0, delta);
    }
    
};
func keyboardHides () {
    
    self.view.transform = CGAffineTransformIdentity
};
}