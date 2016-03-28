//
//  MusicController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/19/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

class MusicController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginToSpotify(sender: AnyObject) {
        let auth = SPTAuth.defaultInstance();
        auth.clientID = "f3838775154a4333b0ea47f84c04cfea"
        auth.redirectURL = NSURL(fileURLWithPath: "bgr://callback");
        auth.requestedScopes = [SPTAuthStreamingScope,SPTAuthUserLibraryReadScope];
        UIApplication.sharedApplication().openURL(auth.loginURL);
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
