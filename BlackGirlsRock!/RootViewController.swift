//
//  RootViewController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/18/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit
import ObjectiveC

private var rootAssociationKey: UInt8 = 0
extension UIViewController
{
    var rootController:RootViewController?{
        get {
            return objc_getAssociatedObject(self, &rootAssociationKey) as? RootViewController
        }
        set(newValue) {
            objc_setAssociatedObject(self, &rootAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

class RootViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var menuView: UIView!
    @IBOutlet var cancelTouchView: UIView!
    @IBOutlet var menuRightConstraint: NSLayoutConstraint!
    var navigation:UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigation.setViewControllers([UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBarController")], animated: false);
        
        self.view.addConstraint(NSLayoutConstraint(item: self.menuView, attribute: .Top, relatedBy: .Equal, toItem: self.navigation.navigationBar, attribute: .Bottom, multiplier: 1, constant: 0));
        
        
        self.setMenu(true, animated: false);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if(segue.identifier == "EmbedNavigation")
        {
            self.navigation = segue.destinationViewController as! UINavigationController
            self.navigation.delegate = self;
        }
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        viewController.rootController = self;
        if(viewController.navigationItem.rightBarButtonItem == nil)
        {
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger"), style: .Plain, target: self, action: Selector("showHideMenu"));
        }
    }
    
    func setMenu(hide:Bool, animated:Bool)
    {
        if ((hide && self.menuRightConstraint.constant != 0) || (!hide && self.menuRightConstraint.constant==0))
        {
            return;
        }
        
        self.menuRightConstraint.constant = hide ? -self.menuView.frame.size.width:0;
        self.cancelTouchView.userInteractionEnabled = !hide
        if(animated)
        {
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.view.layoutIfNeeded();
            })
        }else
        {
            self.view.layoutIfNeeded();
        }
    }
    
    func showHideMenu()
    {
        self.setMenu(self.menuRightConstraint.constant == 0, animated: true)
    }
    
}
