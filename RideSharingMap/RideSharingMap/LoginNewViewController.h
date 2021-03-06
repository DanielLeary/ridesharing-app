//
//  LoginNewViewController.h
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"

@interface LoginNewViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

//logs the user in if all data was correct, if not displays an error message
- (IBAction)login:(id)sender;

@end
