//
//  AwsSesEmail.swift
//  AwsSesDemo
//
//  Created by Graeme McIntosh on 2015/11/09.
//  Copyright © 2015 RevelDigital. All rights reserved.
//

import Foundation

//TODO: The sendRequest should be the only object created in the send method
//TODO: The objects required to make the send request should be created and stored as class objects.

public enum AwsSimulator : String {
    case successAddress
    
    public var stringValue : String
        {
            switch self
            {
            case .successAddress:
                return "success@simulator.amazonses.com"
            }
    }
}

public class AwsConfiguration {
    
    //MARK: Private Properties
    
    private var credentialsProvider  : AWSStaticCredentialsProvider?
    private var accessKey            : String?
    private var secretKey            : String?
    private var region               : AWSRegionType?
    
    //MARK: Constructors
    
    private init()
    {
    }
    
    public class func initialiseDefaultConfiguration(accessKey : String, secretKey: String, region: AWSRegionType) -> AwsConfiguration
    {
        let configuration : AwsConfiguration = AwsConfiguration()
        
        configuration.credentialsProvider = AWSStaticCredentialsProvider.init(
            accessKey: accessKey,
            secretKey: secretKey
        )
        
        configuration.accessKey = accessKey
        configuration.secretKey = secretKey
        
        let defaultServiceConfiguration = AWSServiceConfiguration(
            region: region,
            credentialsProvider: configuration.credentialsProvider
        )
        configuration.region = region
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = defaultServiceConfiguration
        
        return configuration
    }
}

public class AwsSesEmail {
    
    //MARK: Private Properties
    
    private var toAddresses : [String]
    private var fromAddress : String?
    private var subject     : String?
    private var body        : String?
    
    //MARK: Public Properties
    
    public var debug                : Bool
    public var bodyIsHtml           : Bool
    
    //MARK: Constructors
    
    private init()
    {
        self.toAddresses    = [String]()
        self.fromAddress    = nil
        self.subject        = nil
        self.body           = nil
        self.debug          = false
        self.bodyIsHtml     = false
    }
    
    public init(toAddress: String? = nil, fromAddress: String? = nil, subject: String? = nil, body: String? = nil)
    {
        self.toAddresses = [String]()
        
        if let address = toAddress
        {
            self.toAddresses.append(address)
        }
        
        self.fromAddress    = fromAddress
        self.subject        = subject
        self.body           = body
        self.debug          = false
        self.bodyIsHtml     = false
    }
    
    public func addToAddress(toAddress address: String)
    {
        self.toAddresses.append(address)
    }
    
    public func setFromAddress(fromAddress address: String)
    {
        self.fromAddress = address
    }
    
    public func setSubject(subject: String)
    {
        self.subject = subject
    }
    
    public func setBody(body: String, isHtml : Bool = false)
    {
        self.body = body
        self.bodyIsHtml = isHtml
    }
    
    public func send(success: (AnyObject) -> (), failure: (String) -> ())
    {
        if self.body == nil
        {
            print("[ERROR] No body set! Use setBody() method!")
        }
        
        let subject : AWSSESContent = AWSSESContent()
        subject.data = self.subject
        
        let messageBody : AWSSESContent = AWSSESContent()
        messageBody.data = self.body
        let emailBody : AWSSESBody = AWSSESBody()
        emailBody.text = messageBody
        if self.bodyIsHtml
        {
            emailBody.html = messageBody
        }
        let message : AWSSESMessage = AWSSESMessage()
        message.subject = subject
        message.body = emailBody
        
        let destination : AWSSESDestination = AWSSESDestination()
        destination.toAddresses = self.toAddresses
        
        let sendRequest : AWSSESSendEmailRequest = AWSSESSendEmailRequest()
        sendRequest.source = self.fromAddress
        sendRequest.destination = destination
        sendRequest.message = message
        
        if self.debug == true
        {
            print("")
            print("Message Parameters: ")
            print("To: ")
            for str in self.toAddresses
            {
                print("\(str)")
            }
            print("Subject: \(self.subject!)")
            print("From: \(self.fromAddress!)")
            print("Body: \(self.body!)")
            print("")
        }
        
        AWSSES
            .defaultSES()
            .sendEmail(sendRequest)
            .continueWithSuccessBlock {
                (task) -> AnyObject! in
                
                success(task.result)
                
                return task.result
            }
            .continueWithBlock {
                (task) -> AnyObject! in
                
                if self.debug == true
                {
                    print("Response from AWS SES")
                }
                
                //Errors are handled here
                
                if task.error != nil
                {
                    if self.debug
                    {
                        print("Error sending email")
                        let type : String? = task.error.userInfo["Type"] as? String
                        if self.debug == true
                        {
                            print("Type   : \(type!)")
                        }
                        
                        let message : String? = task.error.userInfo["Message"] as? String
                        if self.debug == true
                        {
                            print("Message: \(message!)")
                        }
                        
                        var code : String? = task.error.userInfo["Code"] as? String
                        code = (code != nil ? code : "Unknown")
                        
                        if self.debug == true
                        {
                            print("Code   : \(code!)")
                        }
                        
                        
                        failure("\(code!): \(message!)")
                        
                        return nil
                    }
                }
                
                return nil;
        }
    }
}