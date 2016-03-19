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
    var images: Array<String> = ["Photo1 Gallery Copy 3","Photo1 Gallery","Photo1 Gallery Copy","Photo1 Gallery Copy 2"];
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
        cell.imagePreview.image = UIImage(named: self.images[indexPath.row]);
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 135;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowPhotoFolder", sender: tableView.cellForRowAtIndexPath(indexPath));
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
