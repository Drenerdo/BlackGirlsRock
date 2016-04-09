//
//  VideoGaleryController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/19/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

class VideoGaleryController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var images: Array<Dictionary<String,String>> = [["image":"Photo Gallery Copy 3", "tag":"BGR10Video"],["image":"Photo Gallery", "tag":"RedCarpetVideo"],["image":"Photo Gallery Copy", "tag":"GRTVideo"],["image":"Photo Gallery Copy 2", "tag":"BGRXVideo"]];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "GaleryCell", bundle: nil), forCellReuseIdentifier: "GeleryCell")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("GeleryCell") as! GaleryCell;
        //cell.topLabel.text = "Top \(indexPath.row)";
        //cell.bottomLabel.text = "Bottom \(indexPath.row)";
        cell.imagePreview.image = UIImage(named: self.images[indexPath.row]["image"]!);
        cell.contentView.backgroundColor = UIColor(red: 0.5, green: 0.07, blue: 0.88, alpha: 1.0);
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowVideoFolder", sender: indexPath);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowVideoFolder"
        {
            let dest = segue.destinationViewController as! VideoFolderController
            dest.videoTag = self.images[(sender as! NSIndexPath).row]["tag"];
        }
    }


}
