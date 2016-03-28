//
//  MusicController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/19/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

class MusicController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    var session:SPTSession!
    var trackPage: SPTListPage!
    
    lazy  var player: SPTAudioStreamingController = {
        return SPTAudioStreamingController(clientId: SPTAuth.defaultInstance().clientID);
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.hidden = true;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("spotifyLogin:"), name: "SpotifyLoginCallback", object: nil);
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
       
        self.session = notification.object as! SPTSession;
        
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
        /*
        SPTPlaylistList.playlistsForUserWithSession(self.session) { (error, playlist) -> Void in
            self.tableView.hidden = false;
            self.playList = playlist as! SPTPlaylistList;
            self.tableView.reloadData();
        }*/
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayListCell") as! PlayListCell;
        
        let track = self.trackPage.items[indexPath.row] as! SPTPartialTrack;
        cell.number.text = "\(indexPath.row+1)";
        cell.name.text = track.name;
        var artistNames = Array<String>();
        for artist in track.artists
        {
            artistNames.append((artist as! SPTPartialArtist).name);
        }
        
        //let array = track.artists as NSArray;
        
        cell.artist.text = artistNames.joinWithSeparator(", ");
        let min = NSInteger(track.duration/60);
        let second = NSInteger(track.duration%60);
        cell.duration.text = "\(min):\(second)";
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
        self.player.playURIs(self.trackPage.items, fromIndex: Int32(indexPath.row)) { (error) -> Void in
            print("\(error)");
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
