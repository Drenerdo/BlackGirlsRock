//
//  MyAccountController.swift
//  BlackGirlsRock!
//
//  Created by Сергей on 4/10/16.
//  Copyright © 2016 BGR Enterprises, LLC. All rights reserved.
//

import UIKit

protocol CellDelegate {
    func saveInformation();
    func change(value:AnyObject, forCell:BaseTableCell);
    func showPhotoControl();
    func showDatePicker(cell:BaseTableCell, startValue:NSDate);
    func hideDatePicker();
}

class MyAccountController: UIViewController, UITableViewDelegate, UITableViewDataSource,CellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var datePickerConstraint: NSLayoutConstraint!
    @IBOutlet var datePickerContainer: UIView!
    @IBOutlet var datePicker: UIDatePicker!

    @IBOutlet var tableView: UITableView!
    
    var datePickerRow: NSInteger!
    
    var content: Array<Dictionary<String,AnyObject>> = Array<Dictionary<String,AnyObject>>();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Triangle 1"), style: .Plain, target: self, action: #selector(MyAccountController.backAction))
        
        self.title = "My Account";
        
        self.extensionScrollView = self.tableView;
        
        self.showDatePicker(false, animated: false);
        
        CURRENT_USER.observeEventType(.Value, withBlock: { (snapshot) in
            
            var fn = snapshot.value["firstName"] as? String
            var ln = snapshot.value["lastName"] as? String
            var email = snapshot.value["email"] as? String
            var gender = snapshot.value["gender"] as? String
            var location = snapshot.value["location"] as? String;
            let birthday = snapshot.value["birthday"] as? NSInteger;
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
            if(gender == nil)
            {
                gender = "";
            }
            if(location == nil)
            {
                location = "";
            }
            self.content = [["reuseble":"PhotoCell","height":150,"value":snapshot.value["profileImage"] as! String,"key":"profileImage"],
                ["reuseble":"CellWithTextField","height":60, "title":"FIRST NAME", "value":fn as! AnyObject,"key":"firstName"],
                ["reuseble":"CellWithTextField","height":60, "title":"LAST NAME", "value":ln as! AnyObject, "key":"lastName"],
                ["reuseble":"CellWithTextField","height":60, "title":"BIRTHDAY","key":"birthday", "value":birthday!,"isDate":true],
                ["reuseble":"CellWithTextField","height":60, "title":"EMAIL ADDRESS", "value":email as! AnyObject,"key":"email"],
                ["reuseble":"GenderCell","height":60, "title":"GENDER","value":gender as! AnyObject,"key":"gender"],
                ["reuseble":"CellWithTextField","height":60, "title":"CITY, STATE","value":location as! AnyObject,"key":"location"],
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
        let cell = tableView.dequeueReusableCellWithIdentifier(value["reuseble"] as! String) as! BaseTableCell;
        cell.delegate = self;
        cell.updateWith(value);
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.content[indexPath.row]["height"] as! CGFloat;
    }

    func saveInformation()
    {
        self.view.endEditing(true);
        var userInformation = Dictionary<String,AnyObject>()
        for value in self.content {
            if let key = value["key"] as? String
            {
                userInformation[key] = value["value"]!;
            }
        }
        FIREBASE_REF.childByAppendingPath("users")
            .childByAppendingPath(FIREBASE_REF.authData.uid).setValue(userInformation)
    }
    func change(value: AnyObject, forCell: BaseTableCell) {
        let indexPath = self.tableView.indexPathForCell(forCell)!;
        self.content[indexPath.row]["value"] = value;
    }
    
    func showPhotoControl() {
        let picker = UIImagePickerController();
        picker.delegate = self;
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil);
        let image = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage] as! UIImage, 1);
        self.content[0]["value"] = image?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength);
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .None)
    }
    
    func showDatePicker(cell: BaseTableCell, startValue: NSDate) {
        self.view.endEditing(true);
        self.showDatePicker(true, animated: true)
        self.datePickerRow = self.tableView.indexPathForCell(cell)?.row;
        self.datePicker.date = startValue;
        
    }
    
    func showDatePicker(show:Bool, animated:Bool)
    {
        self.datePickerConstraint.constant = show ? 0 : -self.datePickerContainer.frame.size.height;
        if(animated)
        {
            UIView.animateWithDuration(0.6, animations: { 
                self.view.layoutIfNeeded();
            })
        }
    }
    @IBAction func datePickerChageValue(sender: UIDatePicker) {
        self.content[self.datePickerRow!]["value"] = sender.date.timeIntervalSince1970;
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: self.datePickerRow, inSection: 0)], withRowAnimation: .None)
    }
    
    @IBAction func hideDatePicker() {
        self.showDatePicker(false, animated: true)
    }
}



class BaseTableCell: UITableViewCell
{
    var delegate: CellDelegate?
    func updateWith(info: Dictionary<String,AnyObject>) {
        
    }
}

class PhotoCell: BaseTableCell {
    @IBOutlet var userImage:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.userImage?.layer.cornerRadius = self.userImage!.frame.size.width/2.0;
    }
    
    override func updateWith(info: Dictionary<String, AnyObject>) {
        if let data = NSData(base64EncodedString: info["value"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        {
            self.userImage!.image = UIImage(data: data);
        }
    }
    @IBAction func showPhotoControl(sender: AnyObject) {
        self.delegate?.showPhotoControl();
    }
}

class TextFieldCell: BaseTableCell, UITextFieldDelegate {
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var textField:UITextField?
    var isDate: Bool?
    var dateValue:NSDate?;
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.delegate?.change(textField.text!, forCell: self);
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if self.isDate == true
        {
            
            self.delegate?.showDatePicker(self, startValue: self.dateValue!);
            return false;
        }
        self.delegate?.hideDatePicker();
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func updateWith(info: Dictionary<String, AnyObject>) {
        self.titleLabel?.text = info["title"] as? String;
        self.textField?.text = info["value"] as? String;
        self.isDate = info["isDate"] as? Bool;
        if(self.isDate == true)
        {
            let value = info["value"] as! NSInteger;
            if value != 0
            {
                self.dateValue = NSDate(timeIntervalSince1970: NSTimeInterval(value));
            }else
            {
                self.dateValue = NSDate();
            }
            
            let formatter = NSDateFormatter();
            formatter.dateFormat = "MM'/'dd'/'YYYY"
            self.textField?.text = formatter.stringFromDate(self.dateValue!);
        }
    }
}

class GenderCell: BaseTableCell {
    @IBOutlet var titleLabel:UILabel?
    
    @IBOutlet var maleIndicator: UIView!
    @IBOutlet var femaleIndicator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.maleIndicator.layer.cornerRadius = self.maleIndicator.frame.size.width/2.0;
        self.maleIndicator.layer.borderColor = UIColor.lightGrayColor().CGColor;
        self.femaleIndicator.layer.cornerRadius = self.femaleIndicator.frame.size.width/2.0;
        
        self.femaleIndicator.backgroundColor = UIColor.clearColor();
        self.femaleIndicator.layer.borderWidth = 2.0;
        self.femaleIndicator.layer.borderColor = UIColor.lightGrayColor().CGColor;
    }
    
    override func updateWith(info: Dictionary<String, AnyObject>) {
        self.titleLabel?.text = info["title"] as? String;
        
        self.chageState(info["value"] as? String == "male")
    }
    
    func chageState(male:Bool)
    {
        if male
        {
            self.femaleIndicator.backgroundColor = UIColor.clearColor();
            self.femaleIndicator.layer.borderWidth = 2.0;
            
            self.maleIndicator.layer.backgroundColor = UIColor.whiteColor().CGColor;
            self.maleIndicator.layer.borderWidth = 0.0;
        }else
        {
            self.maleIndicator.backgroundColor = UIColor.clearColor();
            self.maleIndicator.layer.borderWidth = 2.0;
            
            self.femaleIndicator.layer.backgroundColor = UIColor.whiteColor().CGColor;
            self.femaleIndicator.layer.borderWidth = 0.0;
        }
    }
    @IBAction func clickOnMale(sender: AnyObject) {
        self.chageState(true);
        self.delegate?.change("male", forCell: self);
    }
    @IBAction func clickOnFemale(sender: AnyObject) {
        self.chageState(false);
        self.delegate?.change("female", forCell: self);
    }
}

class CellWithButton: BaseTableCell {
    @IBAction func saveClicked()
    {
        self.delegate?.saveInformation();
    }
}