//
//  LoginNewViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "LoginNewViewController.h"
#import "UserModel.h"


@implementation LoginNewViewController {
    
    UserViewModel *viewModel;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserModel *model = [[UserModel alloc] init];
    viewModel = [[UserViewModel alloc] initWithModel:model];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.emailField becomeFirstResponder];
}

- (IBAction)login:(id)sender {
    //if (![viewModel log_in:username.text :password.text])
        self.error_label.text = @"Incorrect email or password";
    //else
        self.error_label.text = @"Logged in successfully";
}


/* KEYBOARD FUNCTIONS */

//dismiss keyboard on done button
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordField) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

//dismiss keyboard on touch outside
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}



@end
