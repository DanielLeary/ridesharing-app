//
//  LoginViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 24/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        usernameField.text = currentUser.username;
        passwordField.text = currentUser.password;
    }   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)input_firstname:(id)sender {
    PFUser *user = [PFUser currentUser];
    if (firstname_field.text != nil && user) {
        user[@"Name"] = firstname_field.text;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }];
    }
}

- (IBAction)input_surname:(id)sender {
    PFUser *user = [PFUser currentUser];
    if (firstname_field.text != nil && user) {
        user[@"Surname"] = surname_field.text;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }];

    }
}

- (IBAction)log_in:(id)sender {
    [PFUser logInWithUsernameInBackground:usernameField.text password:passwordField.text
        block:^(PFUser *user, NSError *error) {
            if (user) {
                // Do stuff after successful login.
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                // The login failed. Check error to see why.
            }
    }];
    
}

- (IBAction)input_user:(id)sender {
}

- (IBAction)input_password:(id)sender {
}

- (IBAction)sign_up:(id)sender {
    NSLog(@"entered signup");
    if (firstname_field.text.length == 0) {
        error_label.text = @"You must provide a Frist Name to sign up!";
        return;
    }
    if (surname_field.text.length == 0) {
        error_label.text = @"You must provide a Surname to sign up!";
        return;
    }
    
    PFUser *user = [PFUser user];
    user.username = usernameField.text;
    user.password = passwordField.text;
    
    user[@"Surname"] = surname_field.text;
    user[@"Name"] = firstname_field.text;
    
    if (position_field.text.length != 0) {
        user[@"Position"] = position_field.text;
    }
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
        }
    }];
}
@end
