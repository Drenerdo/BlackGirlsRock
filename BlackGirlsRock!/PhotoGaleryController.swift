//
//  PhotoGaleryController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/19/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit


class PhotoGaleryController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
//    @IBOutlet var loginButton: UIButton!
    var images: Array<Dictionary<String,String>> = [["image":"Photo1 Gallery Copy 3","tag":"BGR10Photo"],["image":"Photo1 Gallery","tag":"RedCarpetPhoto"],["image":"Photo1 Gallery Copy","tag":"GRTPhoto"],["image":"Photo1 Gallery Copy 2","tag":"BGRXPhoto"]];
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
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowPhotoFolder", sender: indexPath);
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowPhotoFolder"
        {
            let dest = segue.destinationViewController as! PhotoFolderController
            dest.photosTag = self.images[(sender as! NSIndexPath).row]["tag"];
        }
    }


}
