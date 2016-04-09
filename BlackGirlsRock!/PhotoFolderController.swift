//
//  PhotoFolderController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/19/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit
import FlickrKit
import SDWebImage

class PhotoFolderController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var sectionImage: UIImageView!
    @IBOutlet var sectionLableOne: UILabel!
    @IBOutlet var sectionLableTwo: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    var photosTag: NSString?;
    var titleImage: String?;
    
    var photos: NSMutableArray = NSMutableArray();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Triangle 1"), style: .Plain, target: self, action: #selector(PhotoFolderController.backAction))
        self.sectionImage.image = UIImage(named: self.titleImage!);
        
        FlickrKit.sharedFlickrKit().call("flickr.photos.search", args: ["tags":self.photosTag!,"extras":"original_format"]) { (response, error) -> Void in
            
            print("\(response)");
            if response["stat"] as? String == "ok"
            {
              
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.photos.addObjectsFromArray(response["photos"]!["photo"] as! [AnyObject]);
                    self.collectionView.reloadData();
                })
                
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    func backAction()
    {
        self.navigationController?.popViewControllerAnimated(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCollectionCell;
        let photoInfo = self.photos[indexPath.row];
        cell.imageView.sd_setImageWithURL(FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeSmall320, fromPhotoDictionary: photoInfo as! [NSObject : AnyObject]));
        return cell;
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width/2.0,height: collectionView.frame.size.width/2.0);
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetailsPage"
        {
            let cell = sender as! PhotoCollectionCell
            let dest = segue.destinationViewController as! PhotoDetailsController
            dest.previewImage = cell.imageView.image;
            dest.titleImage = self.titleImage;
            dest.imageInfo = self.photos[self.collectionView.indexPathForCell(cell)!.row] as! Dictionary<NSObject, AnyObject>;
        }
    }


}
