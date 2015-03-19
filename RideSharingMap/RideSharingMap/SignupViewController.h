//
//  SignupViewController.h
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewModel.h"

@class LoginViewModel;

@interface SignupViewController : UIViewController{
    
    __weak IBOutlet UITextField *name;
    __weak IBOutlet UITextField *surname;
    __weak IBOutlet UITextField *username;
    __weak IBOutlet UITextField *password;
    __weak IBOutlet UILabel *error_label;
    
    BOOL signup_succ;
}

@property (strong, nonatomic) LoginViewModel *viewModel;
- (void)signup;

@end
