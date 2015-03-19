//
//  LoginNewViewController.h
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewModel.h"

@class LoginViewModel;

@interface LoginNewViewController : UIViewController{
    __weak IBOutlet UILabel *error_label;
    __weak IBOutlet UITextField *username;
    __weak IBOutlet UITextField *password;
    
}
// action that allows unwinding to this view from the Signup view
- (IBAction)backToLoginView:(UIStoryboardSegue *)segue;

- (IBAction)login:(id)sender;

@property (strong, nonatomic) LoginViewModel *viewModel;

@end
