//
//  LoginViewController.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 24/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface LoginViewController : UIViewController{
    __weak IBOutlet UITextField *passwordField;
    __weak IBOutlet UITextField *usernameField;
}

- (IBAction)log_in:(id)sender;
- (IBAction)input_user:(id)sender;
- (IBAction)input_password:(id)sender;

@end
