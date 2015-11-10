# Amazon Web Services Simple Email Service Demo
Demonstration on how to send an email through Amazon's Simple Email Service on iOS 9 using the Swift lanugage.

##Contents

1. [Project description](#project_description)
2. [Installing the Amazon Web Services (AWS) iOS SDK](#installing_aws)
3. [Sending an email](#sending_an_email)

##<a name="project_description"></a>1. Project description
The project demonstrates how to send an email to a single recepient through Amazon's Simple Email Service (SES) on iOS 9 using the Swift language.

Although the project describes how to install SES, you need to have the required credentials in order to send email through this service. These will not be provided for you.

##<a name="installing_aws"></a>2. Installing the Amazon Web Services (AWS) iOS SDK

**2.1 Where to get the AWS iOS SDK**
Download the AWS iOS SDK from http://aws.amazon.com/mobile/sdk/

**2.2 Installing AWS iSO SDK in your project**
The following instructions assume you are using XCode 7 and iOS SDK 9.0. These instructions will probably work for other versions of XCode and the iOS SDK.

1. Open your project in XCode.
2. Open finder.
3. Navigate to the location of the aws-ios-sdk.zip file.
4. Extract the contents of the zip file to a known location.
5. Drag the AWSCore and AWSES frameworks, found in the frameworks subfolder, into your project in XCode.
6. In the project settings, under the "Build Settings" tab, add the AWSCore and AWSSES frameworks to the "Linked Frameworks and Binaries" section.
7. Add the libz1.tdb library to "Linked Frameworks and Binaries" section as well.

**2.3 Create the Bridging Header**
This is only necessary if there is no bridging header in the project.

##<a name="sending_an_email"></a>3. Sending an email
