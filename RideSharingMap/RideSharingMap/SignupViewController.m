//
//  SignupViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "SignupViewController.h"


@implementation SignupViewController {
    BOOL signup_succ;
    UserViewModel *viewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *model = [[UserModel alloc] init];
    viewModel = [[UserViewModel alloc] initWithModel:model];
    signup_succ = false;
}


- (void)viewDidAppear:(BOOL)animated {
    [self.firstNameField becomeFirstResponder];
}


/* METHODS FOR UI */

- (IBAction)nextPressed:(UIButton *)sender {
    NSString *errorText;
    //check for errors
    int error = [viewModel signupWithEmail:self.emailField.text password:self.passwordField.text firstName:self.firstNameField.text andLastName:self.lastNameField.text];

    switch (error) {
        case NO_ERROR:
            [viewModel setFirstName:self.firstNameField.text];
            [viewModel setLastName:self.lastNameField.text];
            errorText = @"Sign up was successful.";
            signup_succ = true;
            break;
        case FIRSTNAME_ERROR:
            signup_succ = false;
            errorText = @"First name must be more than 2 letters.";
            break;
        case LASTNAME_ERROR:
            signup_succ = false;
            errorText = @"Last name must be more than 2 letters.";
            break;
        case EMAIL_ERROR:
            signup_succ = false;
            errorText = @"Email already in use. Please choose another email.";
            break;
        case PASSWORD_ERROR:
            signup_succ = false;
            errorText = @"Password must contain at least one letter and one number, and be at least 6 characters long.";
            break;
        default:
            signup_succ = false;
            break;
    }
    self.errorLabel.text = errorText;

    
    //no errors so perform segue
   if (signup_succ) {
        Signup2ViewController *signup2VC = [self.storyboard instantiateViewControllerWithIdentifier:@"Signup2ViewController"];
        [self.navigationController pushViewController:signup2VC animated:YES];
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
