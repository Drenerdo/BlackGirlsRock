//
//  BaseService.swift
//  BlackGirlsRock!
//
//  Created by Andre Smith on 3/29/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://bgr-app.firebaseio.com/"

let FIREBASE_REF = Firebase(url: BASE_URL)

var CURRENT_USER: Firebase
{
    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
    
    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)

    return currentUser!
}
