//
//  LoginNewViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "LoginNewViewController.h"


@implementation LoginNewViewController {
    
    //UserViewModel *viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //UserModel *model = [[UserModel alloc] init];
    //viewModel = [[UserViewModel alloc] initWithModel:model];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.usernameField becomeFirstResponder];
}

- (IBAction)login:(id)sender {
    User *user = (User *)[PFUser logInWithUsername:self.usernameField.text password:self.passwordField.text];
    if (!user) {
        self.errorLabel.text = @"incorrect email or password";
        self.usernameField.layer.borderColor = [[UIColor redColor] CGColor];
        self.usernameField.layer.borderWidth = 1;
        self.usernameField.layer.cornerRadius = 5;
        self.passwordField.layer.borderColor = [[UIColor redColor] CGColor];
        self.passwordField.layer.borderWidth = 1;
        self.passwordField.layer.cornerRadius = 5;
    } else {
        [User pullFromParse];
        self.errorLabel.text = @"logged in successfully";
        AppDelegate *appDelegeteTemp = [[UIApplication sharedApplication] delegate];
        appDelegeteTemp.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    }
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