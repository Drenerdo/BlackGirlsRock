//
//  LoginViewController.swift
//  BlackGirlsRock!
//
//  Created by Andre Smith on 3/18/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let ref = Firebase(url: "https://bgr-production.firebaseio.com")

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet var loginWithFacebook: UIButton!

    @IBOutlet var loginButton: UIButton!
    
    @IBAction func handleLogin(sender: AnyObject) {
        ref.authUser(emailTextField.text!, password: passwordTextField.text!, withCompletionBlock: { error, authData in
            if error != nil
            {
                print("Unable to signin user")
            }
            else
            {
                let uid = authData.uid
                print("Login successful with uid: \(uid)")
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.loginWithFacebook.setBackgroundImage(UIImage.createWith(UIColor.blackColor()), forState: .Normal);
        self.loginButton.setBackgroundImage(UIImage.createWith(UIColor(red: 0.46, green: 0.08, blue: 0.48, alpha: 1.0)), forState: .Normal);
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: self.emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)]);
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: self.passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)]);
        
        self.keyboardRegister();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing (textField:UITextField)->Bool{
        self.extensionScrollView = scrollView;
        self.curtextfield = textField;
        return true;
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
