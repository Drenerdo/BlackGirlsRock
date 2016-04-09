//
//  MusicController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/19/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class MusicController: UIViewController, UITableViewDataSource, UITableViewDelegate,SPTAudioStreamingDelegate {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    var previewPlayer:AVPlayer?;
    var session:SPTSession!
    var trackPage: SPTListPage!
    
    lazy  var player: SPTAudioStreamingController = {
        let controller = SPTAudioStreamingController(clientId: SPTAuth.defaultInstance().clientID);
        controller.delegate = self;
        return controller;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.hidden = true;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicController.spotifyLogin(_:)), name: "SpotifyLoginCallback", object: nil);
        
        if(SPTAuth.defaultInstance().session != nil)
        {
            self.loginButton.hidden = true;
            self.loadingIndicator.startAnimating();
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { 
                SPTAuth.defaultInstance().renewSession(SPTAuth.defaultInstance().session, callback: { (error, session) in
                    dispatch_sync(dispatch_get_main_queue(), { 
                        if(session != nil)
                        {
                            self.updateWithSession(session);
                        }else if(error == nil)
                        {
                            self.updateWithSession(SPTAuth.defaultInstance().session);
                        }else
                        {
                            self.loadingIndicator.stopAnimating();
                            self.loginButton.hidden = false;
                        }
                    })
                    
                })
            })
            
        }
        //SPTAuth.defaultInstance().renewSession(<#T##session: SPTSession!##SPTSession!#>, callback: <#T##SPTAuthCallback!##SPTAuthCallback!##(NSError!, SPTSession!) -> Void#>)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginToSpotify(sender: AnyObject) {
        self.loginButton.hidden = true;
        self.loadingIndicator.startAnimating();
        let auth = SPTAuth.defaultInstance();
        auth.clientID = "f3838775154a4333b0ea47f84c04cfea"
        auth.redirectURL = NSURL(string: "bgr://callback")
        auth.requestedScopes = [SPTAuthStreamingScope,SPTAuthUserLibraryReadScope];
        UIApplication.sharedApplication().openURL(auth.loginURL);
        
    }
    
    func spotifyLogin(notification:NSNotification)
    {
       
        self.updateWithSession(notification.object as! SPTSession);
    }
    
    func updateWithSession(session: SPTSession) {
        self.session = session;
        self.player.loginWithSession(self.session) { (error) -> Void in
            print("\(error)");
        };
        /*SPTPlaylistSnapshot.playlistsWithURIs([NSURL(string: "spotify:betnetworks:spotify:playlist:5TbE2NJRHA6X2MScPjlV3x")!], session: self.session) { (error, object) -> Void in
         print(object);
         }*/
        do{
            let request = try SPTRequest.createRequestForURL(NSURL(string: "https://api.spotify.com/v1/users/betnetworks/playlists/5TbE2NJRHA6X2MScPjlV3x")!, withAccessToken: self.session.accessToken, httpMethod: "GET", values: nil, valueBodyIsJSON: false, sendDataAsQueryString: false);
            
            SPTRequest.sharedHandler().performRequest(request) { (error, response, data) -> Void in
                do{
                    let playlist = try SPTPlaylistSnapshot(fromData: data, withResponse: response)
                    self.trackPage = playlist.firstTrackPage;
                    self.tableView.hidden = false;
                    self.tableView.reloadData();
                    self.loadingIndicator.stopAnimating();
                }catch {
                    print(error)
                }
            }
        }catch {
            print(error)
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayListCell") as! PlayListCell;
        
        let track = self.trackPage.items[indexPath.row] as! SPTPartialTrack;
        cell.name.text = track.name;
        var artistNames = Array<String>();
        for artist in track.artists
        {
            artistNames.append((artist as! SPTPartialArtist).name);
        }
        
        //let array = track.artists as NSArray;
        
        cell.artist.text = artistNames.joinWithSeparator(", ");
        if track.album.smallestCover != nil{
            cell.songImage.sd_setImageWithURL(track.album.smallestCover.imageURL);
        }
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.trackPage != nil
        {
            return self.trackPage.range.length;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        let track = self.trackPage.items[indexPath.row] as! SPTPartialTrack;
        if self.previewPlayer != nil
        {
            self.previewPlayer?.pause();
        }
        let player = AVPlayer(URL:track.previewURL);
        self.previewPlayer = player
        self.previewPlayer!.play();
        
        
        //self.player.playURIs(self.trackPage.items, fromIndex: Int32(indexPath.row)) { (error) -> Void in
        //    print("\(error)");
       // }
    }
    
    
    func audioStreamingDidLogin(audioStreaming: SPTAudioStreamingController!) {
        print("\(#function)");
    }
    
    func audioStreamingDidLogout(audioStreaming: SPTAudioStreamingController!) {
        print("\(#function)");
    }
    
    func audioStreamingDidEncounterTemporaryConnectionError(audioStreaming: SPTAudioStreamingController!) {
        print("\(#function)");
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didEncounterError error: NSError!) {
        print("\(#function) \(error.localizedDescription)");
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didReceiveMessage message: String!) {
        print("\(#function) \(message)");
    }
   
    func audioStreamingDidDisconnect(audioStreaming: SPTAudioStreamingController!) {
        print("\(#function)");
    }
    
    func audioStreamingDidReconnect(audioStreaming: SPTAudioStreamingController!) {
        print("\(#function)");
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80;
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
