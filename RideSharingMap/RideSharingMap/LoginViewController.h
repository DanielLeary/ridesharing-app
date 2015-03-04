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
    __weak IBOutlet UITextField *firstname_field;
    __weak IBOutlet UITextField *surname_field;
    __weak IBOutlet UILabel *error_label;
}

- (IBAction)input_firstname:(id)sender;
- (IBAction)input_surname:(id)sender;

- (IBAction)log_in:(id)sender;
- (IBAction)input_user:(id)sender;
- (IBAction)input_password:(id)sender;
- (IBAction)sign_up:(id)sender;

@end
