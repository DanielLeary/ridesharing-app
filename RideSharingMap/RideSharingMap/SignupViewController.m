//
//  SignupViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "SignupViewController.h"
#import "UserModel.h"


@implementation SignupViewController {
    
    BOOL signup_succ;
    LoginViewModel *viewModel;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *model = [[UserModel alloc] init];
    viewModel = [[LoginViewModel alloc] initWithModel:model];
    signup_succ = false;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.firstNameField becomeFirstResponder];
}


/* METHODS FOR UI */

- (IBAction)nextPressed:(UIButton *)sender {
    NSString *errorText;
    //check for errors
    int error = [viewModel checkForSignupErrors:self.firstNameField.text andLastName:self.lastNameField.text andPassword:self.passwordField.text];
    /*
    int error = [viewModel sign_up:self.emailField.text
                                  :self.passwordField.text
                                  :self.firstNameField.text
                                  :self.lastNameField.text];*/
    switch (error) {
        case NO_ERROR:
            [viewModel inputFirstName:self.firstNameField.text];
            [viewModel inputSurname:self.lastNameField.text];
            errorText = @"Sign up was successful.";
            signup_succ = true;
            break;
        case NAME_ERROR:
            signup_succ = false;
            errorText = @"First name must be more than 2 letters.";
            break;
        case SURNAME_ERROR:
            signup_succ = false;
            errorText = @"Last name must be more than 2 letters.";
            break;
        case USERNAME_ERROR:
            signup_succ = false;
            errorText = @"Email already in use. Please choose another email.";
            break;
        case PASSWORD_ERROR:
            signup_succ = false;
            errorText = @"Password must contain at least one letter and one number, and be at least 6 characters long.";
        default:
            signup_succ = false;
            break;
    }
    self.errorLabel.text = errorText;
    
    //no errors so perform segue
    if (signup_succ) {
        [self shouldPerformSegueWithIdentifier:@"gotoSignup2" sender:self];
        /*
        Signup2ViewController *signup2VC = [self.storyboard instantiateViewControllerWithIdentifier:@"Signup2ViewController"];
        [self.navigationController pushViewController:signup2VC animated:YES];*/
    }
}

/*
- (void)signup{
    int error = [viewModel sign_up:username.text :password.text :name.text :surname.text];
    NSString *error_text;
    switch (error) {
        case NO_ERROR:
            [viewModel inputFirstName:name.text];
            [viewModel inputSurname:surname.text];
            error_text = @"Sign up was successfull";
            signup_succ = true;
            
            break;
        case NAME_ERROR:
            signup_succ = false;
            error_text = @"Incorrect Name, signup unsuccessful";
            break;
        case SURNAME_ERROR:
            signup_succ = false;
            error_text = @"Incorrect Surname, signup unsiccessful";
            break;
        case USERNAME_ERROR:
            signup_succ = false;
            error_text = @"Username already in use. Please choose another uesrname";
            break;
        case PASSWORD_ERROR:
            signup_succ = false;
            error_text = @"Password must contain at least one letter and number, and be at least 6 characters long";
        default:
            signup_succ = false;
            break;
    }
    self.errorLabel.text = error_text;
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self signup];
    if ([identifier isEqualToString:@"gotoSignup2"]) {
        if (signup_succ)
            return YES;
        else
            return NO;
    }
    
    return YES;
}*/


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
