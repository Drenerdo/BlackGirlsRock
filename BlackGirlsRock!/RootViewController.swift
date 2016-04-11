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
            self.didSetRootController();
        }
    }
    
    func didSetRootController()
    {
        
    }
}

class RootViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var launchImage: UIImageView!
    @IBOutlet var menuView: UIView!
    @IBOutlet var cancelTouchView: UIView!
    @IBOutlet var menuRightConstraint: NSLayoutConstraint!
    var menuItems:Array<Dictionary<String,Any>>!;
    var navigation:UINavigationController!
    @IBOutlet var accountImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.navigation.setViewControllers([UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")], animated: false);
        self.launchImage.hidden = false;
        FIREBASE_REF.observeAuthEventWithBlock { (authData) in
            //print(authData);
            if authData != nil
            {
                FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(authData.uid).observeEventType(.Value, withBlock: { (snapshot) in
                        if let image = snapshot.value.valueForKey("profileImage") as? String
                        {
                            
                            if let data = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                            {
                                self.accountImage.image = UIImage(data: data);
                            }
                        }
                        
                        let fn = snapshot.value["firstName"] as? String
                        let ln = snapshot.value["lastName"] as? String
                        
                        if ln != nil && fn != nil
                        {
                            self.userName.text = "\(fn!)\r\n\(ln!)"
                        }
                        self.launchImage.hidden = true;
                    
                    }, withCancelBlock: { (error) in
                });
                
                self.navigation.setViewControllers([UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TabBarController")], animated: true);
            }else
            {
                self.launchImage.hidden = true;
                self.navigation.setViewControllers([UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")], animated: true);
            }
        }

        self.setMenu(true, animated: false);
        
        self.accountImage.layer.cornerRadius = self.accountImage.frame.size.width/2.0;
        self.accountImage.clipsToBounds = true;
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
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburger"), style: .Plain, target: self, action: #selector(RootViewController.showHideMenu));
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
    
    @IBAction func logOut(sender: AnyObject) {
        self.setMenu(true, animated: true)
        FIREBASE_REF.unauth();
        SPTAuth.defaultInstance().session = nil;
    }
    @IBAction func openShop(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://blackgirlsrock.gomerch.com/")!);
    }
    @IBAction func showMyAccount(sender: AnyObject) {
        self.setMenu(true, animated: true);
        
        self.navigation.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyAccountController"), animated: true);
        
    }
}
