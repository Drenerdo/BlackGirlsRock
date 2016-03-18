//
//  CreateAccountViewController.swift
//  BlackGirlsRock!
//
//  Created by Andre Smith on 3/18/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    let ref = Firebase(url: "https://bgr-production.firebaseio.com")

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for textField in self.textFields
        {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)]);
        }
        
        self.facebookButton.setBackgroundImage(UIImage.createWith(UIColor.blackColor()), forState: .Normal);
        self.signInButton.setBackgroundImage(UIImage.createWith(UIColor(red: 0.46, green: 0.08, blue: 0.48, alpha: 1.0)), forState: .Normal);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToLogIn(sender: AnyObject) {
        self.navigationController?.setViewControllers([UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")], animated: true)
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
