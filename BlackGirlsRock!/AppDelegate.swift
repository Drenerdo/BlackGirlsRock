//
//  AppDelegate.swift
//  BlackGirlsRock!
//
//  Created by Andre Smith on 3/18/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FlickrKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //@property (nonatomic, strong) SPTSession *session;
    //@property (nonatomic, strong) SPTAudioStreamingController *player;
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().translucent = false;
        UINavigationBar.appearance().tintColor = UIColor.whiteColor();
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FlickrKit.sharedFlickrKit().initializeWithAPIKey("41818ce2b48d0d0fc8522ae4dc7d3796", sharedSecret: "69e8c738963d7b5b")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if(SPTAuth.defaultInstance().canHandleURL(url))
        {
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: { (error, seesion) -> Void in
                
                NSNotificationCenter.defaultCenter().postNotificationName("SpotifyLoginCallback", object: seesion)
                }
            )
            return true;
        }

        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }


}

extension NSURL
{
    class func flickrPhotoURL(forSize:FKPhotoSize, fromPhotoDictionary photoDict:NSDictionary) -> NSURL
    {
        var photoID = photoDict["id"] as? String;
        if (photoID == nil) {
            photoID = photoDict["primary"]  as? String; //sets return this
        }
        
        //Find possible server
        let server = photoDict["server"] as! String;
        
        //Find possible farm
        let farm = photoDict["farm"]?.stringValue;
        
        //Find possible secret
        var type: String = "jpg"
        var secret = photoDict["secret"]  as! String;
        if forSize == FKPhotoSizeOriginal
        {
            type = photoDict["originalformat"]  as! String;
            secret = photoDict["originalsecret"]  as! String;
        }
        return NSURL.flickrPhotoURL(forSize, photoID: photoID!, server: server, secret: secret, farm: farm!, type: type);
    }
    
    class func flickrPhotoURL(forSize:FKPhotoSize, photoID:String, server:String, secret:String, farm:String, type: String) ->
NSURL    {
    
    let photoSource = "https://static.flickr.com/";
    
    var URLString = "https://";
    if (farm.characters.count > 0) {
        URLString += "farm\(farm)."
    }
    
    URLString += photoSource.substringFromIndex(URLString.startIndex.advancedBy(8))

    URLString += "\(server)/\(photoID)_\(secret)"
    
    
    let sizeKey = FKIdentifierForSize(forSize);
    URLString += "_\(sizeKey).\(type)";
   
    
    return NSURL(string: URLString)!;
   /* - (NSURL *) photoURLForSize:(FKPhotoSize)size photoID:(NSString *)photoID server:(NSString *)server secret:(NSString *)secret farm:(NSString *)farm {
    // https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
    // https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
    
    */
    }

}

