//
//  PhotoDetailsController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 3/19/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

class VideoDetailsController: UIViewController,UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var descriptionLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureScrollView();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
    
        super.viewDidLayoutSubviews();
        self.configureScrollView();
    }
    
    func configureScrollView()
    {
        let scrollViewFrame = self.scrollView.frame;
        let scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
        let scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
        let minScale = min(scaleWidth, scaleHeight);
        self.scrollView.minimumZoomScale = minScale;

        self.scrollView.maximumZoomScale = 1.0;
    }
    
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.photo;
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        var topInset = (scrollView.frame.size.height - scrollView.contentSize.height)/2;
        if(topInset<0)
        {
            topInset = 0;
        }
        var leftInset = (scrollView.frame.size.width - scrollView.contentSize.width)/2;
        if(leftInset<0)
        {
            leftInset = 0;
        }
        scrollView.contentInset = UIEdgeInsetsMake(topInset, leftInset, 0, 0);
    }
    
    @IBAction func clickOnShare(sender: AnyObject) {
        
        let activity = UIActivityViewController(activityItems: [self.photo], applicationActivities: nil);
        self.presentViewController(activity, animated: true, completion: nil);
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
