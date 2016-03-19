//
//  TabBarController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/18/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

class TabBarController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var galeryButton: UIButton!
    @IBOutlet var videoButton: UIButton!
    @IBOutlet var musicButton: UIButton!
    
    @IBOutlet var menuButtons: [UIButton]!
    @IBOutlet var menuSlider: UIView!
    
    @IBOutlet var contentView: UIView!
    
    var prevSelectedButton : UIButton!
    
    lazy var photoGaleriController: UIViewController = {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PhotoGaleryNavigation") as! UINavigationController
        controller.delegate = self;
        controller.view.translatesAutoresizingMaskIntoConstraints = false;
        return controller
    }()
    lazy var videoGaleriController: UIViewController = {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("VideoGaleryNavigation") as! UINavigationController
        controller.delegate = self;
        controller.view.translatesAutoresizingMaskIntoConstraints = false;
        return controller
    }()
    lazy var musicController: UIViewController = {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MusicController")
        controller.view.translatesAutoresizingMaskIntoConstraints = false;
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in menuButtons
        {
            button.setImage(button.imageForState(.Normal)?.imageWithColor(button.tintColor), forState: .Selected);
        }
        
        self.selectMenu(self.galeryButton);
        // Do any additional setup after loading the view.
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        viewController.rootController = self.rootController;
        self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getIndexOfButton(button:UIButton)->NSInteger
    {
        switch (button)
        {
        case self.galeryButton:
            return 0;
        case self.videoButton:
            return 1;
        case self.musicButton:
            return 2;
        default:
            return -1
        }
    }
    
    func getControllerForIndex(index:NSInteger)->UIViewController?
    {
        switch (index)
        {
        case 0:
            return self.photoGaleriController;
        case 1:
            return self.videoGaleriController;
        case 2:
            return self.musicController;
        default:
            return nil
        }
    }
    
    @IBAction func selectMenu(sender: UIButton) {
        if(sender.selected)
        {
            return;
        }
        
        
        let finalIndex = self.getIndexOfButton(sender);
        var firstIndex = finalIndex;
        if(self.prevSelectedButton != nil)
        {
            self.prevSelectedButton.selected = false
            firstIndex = self.getIndexOfButton(self.prevSelectedButton);
        }
        self.prevSelectedButton = sender;
        sender.selected = true;
        var curIndex = firstIndex;
        while (finalIndex != curIndex)
        {
            if(finalIndex>firstIndex)
            {
                curIndex++;
            }else
            {
                curIndex--;
            }
            let controller = self.getControllerForIndex(curIndex)!
            self.addChildViewController(controller);
            self.contentView.addSubview(controller.view)
            self.contentView.addConstraints([NSLayoutConstraint(item: self.contentView, attribute: .Left, relatedBy: .Equal, toItem: controller.view, attribute: .Left, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.contentView, attribute: .Right, relatedBy: .Equal, toItem: controller.view, attribute: .Right, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.contentView, attribute: .Top, relatedBy: .Equal, toItem: controller.view, attribute: .Top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: self.contentView, attribute: .Bottom, relatedBy: .Equal, toItem: controller.view, attribute: .Bottom, multiplier: 1, constant: 0)])
            
            controller.view.transform = CGAffineTransformMakeTranslation(self.contentView.frame.size.width*CGFloat(curIndex-firstIndex), 0);
        }
        
        let controller = self.getControllerForIndex(finalIndex)!
        self.navigationItem.leftBarButtonItem = controller.navigationItem.leftBarButtonItem
        if let navigation = controller as? UINavigationController
        {
            self.navigationItem.leftBarButtonItem = navigation.visibleViewController?.navigationItem.leftBarButtonItem;
        }
        self.addChildViewController(controller);
        self.contentView.addSubview(controller.view)
        self.contentView.addConstraints([NSLayoutConstraint(item: self.contentView, attribute: .Left, relatedBy: .Equal, toItem: controller.view, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentView, attribute: .Right, relatedBy: .Equal, toItem: controller.view, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentView, attribute: .Top, relatedBy: .Equal, toItem: controller.view, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.contentView, attribute: .Bottom, relatedBy: .Equal, toItem: controller.view, attribute: .Bottom, multiplier: 1, constant: 0)])
        
        controller.view.transform = CGAffineTransformMakeTranslation(self.contentView.frame.size.width*CGFloat(finalIndex-firstIndex), 0);
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.menuSlider.transform = CGAffineTransformMakeTranslation(self.menuSlider.frame.size.width*CGFloat(finalIndex), 0);
                var curIndex = firstIndex;
                while (finalIndex != curIndex)
                {
                    
                    let controller = self.getControllerForIndex(curIndex)!
                    controller.view.transform = CGAffineTransformMakeTranslation(self.contentView.frame.size.width*CGFloat(curIndex-finalIndex), 0);
                    if(finalIndex>firstIndex)
                    {
                        curIndex++;
                    }else
                    {
                        curIndex--;
                    }
                }
                let controller = self.getControllerForIndex(finalIndex)!
                controller.view.transform = CGAffineTransformIdentity;
            }) { (complete) -> Void in
                var curIndex = firstIndex;
                while (finalIndex != curIndex)
                {
                    
                    let controller = self.getControllerForIndex(curIndex)!
                    controller.view.removeFromSuperview();
                    controller.removeFromParentViewController();
                    if(finalIndex>firstIndex)
                    {
                        curIndex++;
                    }else
                    {
                        curIndex--;
                    }
                }
        }
       
    }
    
    override func didSetRootController()
    {
        super.didSetRootController();
        let navigation = self.photoGaleriController as! UINavigationController;
        for controller in navigation.viewControllers
        {
            controller.rootController = self.rootController;
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
