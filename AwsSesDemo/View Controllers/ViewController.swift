//
//  ViewController.swift
//  AwsSesDemo
//
//  Created by Graeme McIntosh on 2015/11/03.
//  Copyright © 2015 RevelDigital. All rights reserved.
//

import UIKit

public class ViewController : UIViewController {
    
    //MARK: Constants
    
    private let accessKey           : String = <add access key>
    private let secretKey           : String = <add secret key>
    private let fromEmailAddress    : String = <add from email address>
    
    //MARK: IBOutlets
    
    @IBOutlet var emailAddress  : UITextField?
    @IBOutlet var subject       : UITextField?
    @IBOutlet var body          : UITextView?
    @IBOutlet var image         : UIImageView?
    
    //MARK: Private Methods
    
    /// Helper method to display an error dialog containing a message.
    private func displayError(errorMessage : String)
    {
        dispatch_async(dispatch_get_main_queue())
            {
                let alertController : UIAlertController = UIAlertController(
                    title: "Error",
                    message: errorMessage,
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                let closeAction : UIAlertAction = UIAlertAction(
                    title: "Ok",
                    style: UIAlertActionStyle.Default) {
                        (action) -> Void in
                        
                }
                alertController.addAction(closeAction)
                
                self.presentViewController(
                    alertController,
                    animated: true,
                    completion: nil
                )
        }
    }
    
    //MARK: View Lifecycle Methods
    
    public override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    //MARK: IBActions
    
    /// Clear the form when tapped
    @IBAction
    public func didTapClearButton(sender: UIButton)
    {
        self.emailAddress!.text = ""
        self.subject!.text = ""
        self.body!.text = ""
    }
    
    /// Send the email
    @IBAction
    public func didTabSendButton(sender: UIButton)
    {
        //First, validate the parameters
        if self.body!.text!.isEmpty
        {
            self.displayError("Email body is nil! Please add text for the body.")
            
            return
        }
        
        if self.emailAddress!.text!.isEmpty
        {
            self.displayError("Email address is nil! Please add an email address")
            
            return
        }
        
        if self.subject!.text!.isEmpty
        {
            self.displayError("Subject is nil! Please add an email address")
            
            return
        }
        
        //Step 1: Create the client / Authentication Stuff
        let _ : AwsConfiguration = AwsConfiguration.initialiseDefaultConfiguration(
            self.accessKey,
            secretKey: self.secretKey,
            region: AWSRegionType.USEast1
        )
        
        //Step 2: Create the email
        let awsSesEmail : AwsSesEmail = AwsSesEmail()
        awsSesEmail.setBody("<h1> how is it going?</h1><img src=\"https://s3.amazonaws.com/Traffic_Email_Templates/Appetizer/2_3col.jpg\" width=\"180\" height=\"180\" />", isHtml: false)
        //awsSesEmail.setBody("This is a plain text test email!")
        
        awsSesEmail.setSubject(self.subject!.text!)
        //NOTE: Only a single email address is handled
        awsSesEmail.addToAddress(toAddress: self.emailAddress!.text!)
        awsSesEmail.setFromAddress(fromAddress: self.fromEmailAddress)
        awsSesEmail.debug = true
        
        //Step 3: Sending the email
        awsSesEmail.send(
            {
                (result) in
                
                print("Success: \(result)")
            },
            failure: {
                (reason) in
                
                print("\(reason)")
            }
        )
        
    }
}
