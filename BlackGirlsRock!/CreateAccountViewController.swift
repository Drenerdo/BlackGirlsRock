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
    
    let ref = Firebase(url: "https://bgr-app.firebaseio.com/")

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var facebookButton: UIButton!
    
    @IBOutlet weak var firstnameField: UITextField!
    
    @IBOutlet weak var lastnameField: UITextField!
    
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func createAccountAction(sender: AnyObject)
    {
        let email = self.emailField.text
        let password = self.passwordField.text
        
        if email != "" && password != ""
        {
            FIREBASE_REF.createUser(email, password: password, withValueCompletionBlock: { (error, authData) -> Void in
                
                if error == nil
                {
                    FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
                        if error == nil
                        {
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                            print("Account Created!")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        else
                        {
                            print(error)
                        }
                    })
                }
                else
                {
                    print(error)
                }
                
            })
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Enter email and password", preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            
            alert.addAction(action)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        for textField in self.textFields
        {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)]);
        }
        
        self.facebookButton.setBackgroundImage(UIImage.createWith(UIColor.blackColor()), forState: .Normal);
        self.signInButton.setBackgroundImage(UIImage.createWith(UIColor(red: 0.46, green: 0.08, blue: 0.48, alpha: 1.0)), forState: .Normal);
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
