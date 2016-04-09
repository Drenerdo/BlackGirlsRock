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
    
    var content: Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Triangle 1"), style: .Plain, target: self, action: #selector(MyAccountController.backAction))
        
        self.title = "My Account";
        
        self.extensionScrollView = self.tableView;
        
        CURRENT_USER.observeEventType(.Value, withBlock: { (snapshot) in
            
            var fn = snapshot.value["firstName"] as? String
            var ln = snapshot.value["lastName"] as? String
            var email = snapshot.value["email"] as? String
            if fn == nil
            {
                fn = "";
            }
            if ln == nil
            {
                ln = "";
            }
            if email == nil
            {
                email = "";
            }
            self.content = [["reuseble":"PhotoCell","height":150,"photoURL":snapshot.value["profileImage"] as! String],
                ["reuseble":"CellWithTextField","height":60, "title":"FIRST NAME", "value":fn as! AnyObject],
                ["reuseble":"CellWithTextField","height":60, "title":"LAST NAME", "value":ln as! AnyObject],
                ["reuseble":"CellWithTextField","height":60, "title":"BIRTHDAY"],
                ["reuseble":"CellWithTextField","height":60, "title":"EMAIL ADDRESS", "value":email as! AnyObject],
                ["reuseble":"GenderCell","height":60, "title":"GENDER"],
                ["reuseble":"CellWithTextField","height":60, "title":"CITY, STATE"],
                ["reuseble":"SaveButton","height":80]
            ];
            
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
        
       // self.keyboardRegister();
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
        let value = self.content[indexPath.row];
        let cell = tableView.dequeueReusableCellWithIdentifier(value["reuseble"] as! String);
        cell?.updateWith(value);
        return cell!;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       // return self.content[indexPath.row]["height"].floatValue;
        return self.content[indexPath.row]["height"] as! CGFloat;
    }

}

extension UITableViewCell
{
    func updateWith(info: Dictionary<String,AnyObject>) {
        
    }
}

class PhotoCell: UITableViewCell {
    @IBOutlet var userImage:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.userImage?.layer.cornerRadius = self.userImage!.frame.size.width/2.0;
    }
    
    override func updateWith(info: Dictionary<String, AnyObject>) {
        self.userImage?.sd_setImageWithURL(NSURL(string: info["photoURL"] as! String)!)
    }
}

class TextFieldCell: UITableViewCell {
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var textField:UITextField?
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    override func updateWith(info: Dictionary<String, AnyObject>) {
        self.titleLabel?.text = info["title"] as? String;
        self.textField?.text = info["value"] as? String;
    }
}

class GenderCell: UITableViewCell {
    @IBOutlet var titleLabel:UILabel?
    
    @IBOutlet var maleIndicator: UIView!
    @IBOutlet var femaleIndicator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.maleIndicator.layer.cornerRadius = self.maleIndicator.frame.size.width/2.0;
        self.femaleIndicator.layer.cornerRadius = self.femaleIndicator.frame.size.width/2.0;
        
        self.femaleIndicator.backgroundColor = UIColor.clearColor();
        self.femaleIndicator.layer.borderWidth = 2.0;
        self.femaleIndicator.layer.borderColor = UIColor.lightGrayColor().CGColor;
    }
    
    override func updateWith(info: Dictionary<String, AnyObject>) {
        self.titleLabel?.text = info["title"] as? String;
    }
}