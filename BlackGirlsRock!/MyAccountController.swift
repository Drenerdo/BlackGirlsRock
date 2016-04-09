//
//  MyAccountController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 4/10/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

class MyAccountController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var content: Array<Dictionary<String,String>> = Array<Dictionary<String,String>>();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Triangle 1"), style: .Plain, target: self, action: #selector(MyAccountController.backAction))
        
        self.title = "My Account";
        
        self.extensionScrollView = self.tableView;
        
        CURRENT_USER.observeEventType(.Value, withBlock: { (snapshot) in
            self.content = [["reuseble":"PhotoCell","height":"150","photoURL":snapshot.value["profileImage"] as! String]];
            
            self.tableView.reloadData();
        })
        //
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.keyboardRegister();
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        
        self.keyboardUnreigster();
    }
    

    func backAction() {
        self.navigationController?.popViewControllerAnimated(true);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell(style: .Default, reuseIdentifier: "test");
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return self.content[indexPath.row]["height"].floatValue;
        return 0;
    }

}
