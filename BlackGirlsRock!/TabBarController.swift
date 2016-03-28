//
//  TabBarController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/18/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

class TabBarController: UIViewController, UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    @IBOutlet var galeryButton: UIButton!
    @IBOutlet var videoButton: UIButton!
    @IBOutlet var musicButton: UIButton!
    
    @IBOutlet var menuButtons: [UIButton]!
    @IBOutlet var menuSlider: UIView!
    
    @IBOutlet var contentView: UIView!
    
    var prevSelectedButton : UIButton!
    
    var currentContentController:UIViewController!
    var tmpContentController:UIViewController!
    
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
    func getIndexOfController(controller:UIViewController?)->NSInteger
    {
        if let stc:UIViewController = controller
        {
            switch (stc)
            {
            case self.photoGaleriController:
                return 0;
            case self.videoGaleriController:
                return 1;
            case self.musicController:
                return 2;
            default:
                return -1
            }
        }
        return -1;
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
    
    func getButtonForIndex(index:NSInteger)->UIButton?
    {
        switch (index)
        {
        case 0:
            return self.galeryButton;
        case 1:
            return self.videoButton;
        case 2:
            return self.musicButton;
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
        self.currentContentController = controller;
        
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
    
    @IBAction func swipeMenu(sender: UIPanGestureRecognizer)
    {
        switch (sender.state)
        {
        case .Began:
            self.tmpContentController = nil;
        case .Changed:
            
            let index = self.getIndexOfController(self.currentContentController);
            let tmpIndex = self.getIndexOfController(self.tmpContentController);
            let translation = sender.translationInView(self.contentView).x;
            
            let nextIndex = index+(translation<0 ? 1 : -1);
            if(tmpIndex != nextIndex)
            {
                if(tmpIndex>=0)
                {
                    self.tmpContentController.removeFromParentViewController();
                    self.tmpContentController.view.removeFromSuperview();
                    self.tmpContentController = nil
                }
                if(nextIndex>=0&&nextIndex<=2)
                {
                    self.tmpContentController = self.getControllerForIndex(nextIndex);
                    self.addChildViewController(tmpContentController);
                    self.contentView.addSubview(self.tmpContentController.view);
                    self.contentView.addConstraints([NSLayoutConstraint(item: self.contentView, attribute: .Left, relatedBy: .Equal, toItem: self.tmpContentController.view, attribute: .Left, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self.contentView, attribute: .Right, relatedBy: .Equal, toItem: self.tmpContentController.view, attribute: .Right, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self.contentView, attribute: .Top, relatedBy: .Equal, toItem: self.tmpContentController.view, attribute: .Top, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: self.contentView, attribute: .Bottom, relatedBy: .Equal, toItem: self.tmpContentController.view, attribute: .Bottom, multiplier: 1, constant: 0)])
                }
            }
            
            if((index == 0 && translation>0)||(index==2&&translation<0))
            {
                self.currentContentController.view.transform = CGAffineTransformMakeTranslation((translation>0 ? 1.0 : -1.0)*sqrt(abs(translation)*20), 0);
                self.menuSlider.transform = CGAffineTransformMakeTranslation((translation>0 ? -1.0 : 1.0)*sqrt(abs(translation)*20)*self.menuSlider.frame.size.width/self.contentView.frame.size.width + self.menuSlider.frame.size.width*CGFloat(index), 0)
            }else
            {
                self.currentContentController.view.transform = CGAffineTransformMakeTranslation(translation, 0);
                if(self.tmpContentController != nil)
                {
                    self.tmpContentController.view.transform = CGAffineTransformMakeTranslation((translation<0 ? 1.0 : -1.0)*self.contentView.frame.size.width + translation, 0);
                }
                self.menuSlider.transform = CGAffineTransformMakeTranslation(self.menuSlider.frame.size.width*CGFloat(index)-translation*self.menuSlider.frame.size.width/self.contentView.frame.size.width, 0)
            }
        case .Ended:
            
                UIView.animateWithDuration(0.6, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
                var index = self.getIndexOfController(self.currentContentController);
                let translation = sender.translationInView(self.contentView).x;
                let velocity = sender.velocityInView(self.contentView);
                let endPoint = translation + velocity.x / 20.0;
                if((index == 0 && translation>0)||(index==2&&translation<0))
                {
                    self.currentContentController.view.transform = CGAffineTransformIdentity
                    
                }else if(abs(endPoint)>self.contentView.frame.size.width/2)
                {
                    let tmpIndex = self.getIndexOfController(self.tmpContentController);
                    self.currentContentController.view.transform = CGAffineTransformMakeTranslation((translation>0 ? 1.0 : -1.0)*self.contentView.frame.size.width, 0);
                    self.tmpContentController.view.transform = CGAffineTransformIdentity
                    
                    let tmp = self.currentContentController
                    self.currentContentController = self.tmpContentController;
                    self.tmpContentController = tmp;
                    
                    self.getButtonForIndex(tmpIndex)?.selected = true;
                    self.getButtonForIndex(index)?.selected = false;
                    index = tmpIndex;
                }else
                {
                    self.currentContentController.view.transform = CGAffineTransformIdentity
                    self.tmpContentController.view.transform = CGAffineTransformMakeTranslation((translation<0 ? 1.0 : -1.0)*self.contentView.frame.size.width, 0);
                }
                
               
                self.menuSlider.transform = CGAffineTransformMakeTranslation(self.menuSlider.frame.size.width*CGFloat(index), 0)
                }, completion: { (complete) -> Void in
                    
                    if(self.tmpContentController != nil)
                    {
                        self.tmpContentController.removeFromParentViewController();
                        self.tmpContentController.view.removeFromSuperview();
                        self.tmpContentController = nil
                    }
                    self.navigationItem.leftBarButtonItem = self.currentContentController.navigationItem.leftBarButtonItem
                    if let navigation = self.currentContentController as? UINavigationController
                    {
                        self.navigationItem.leftBarButtonItem = navigation.visibleViewController?.navigationItem.leftBarButtonItem;
                    }
            } )
            
            
            
        default: break
            
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
