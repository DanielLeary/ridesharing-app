//
//  SignupViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "SignupViewController.h"


@implementation SignupViewController {
    
    BOOL inputError;
    //UserViewModel *viewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //UserModel *model = [[UserModel alloc] init];
    //viewModel = [[UserViewModel alloc] initWithModel:model];
    inputError = YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [self.firstNameField becomeFirstResponder];
}


/* METHODS FOR UI */

- (IBAction)nextPressed:(UIButton *)sender {
    NSString *errorText;
    int error = [self checkSignupErrors];

    switch (error) {
        case NO_ERROR:
            //[user setFirstName:self.firstNameField.text];
            //[user setLastName:self.lastNameField.text];
            errorText = @"Sign up was successful.";
            inputError = NO;
            break;
        case FIRSTNAME_ERROR:
            inputError = YES;
            errorText = @"First name must be more than 2 letters.";
            break;
        case LASTNAME_ERROR:
            inputError = YES;
            errorText = @"Last name must be more than 2 letters.";
            break;
        case EMAIL_ERROR:
            inputError = YES;
            errorText = @"Email already in use. Please choose another email.";
            break;
        case PASSWORD_ERROR:
            inputError = YES;
            errorText = @"Password must contain at least one letter and one number, and be at least 6 characters long.";
            break;
        default:
            inputError = YES;
            break;
    }
    self.errorLabel.text = errorText;

    //no errors so perform segue
   if (!inputError) {
        Signup2ViewController *signup2VC = [self.storyboard instantiateViewControllerWithIdentifier:@"Signup2ViewController"];
       signup2VC.firstName = self.firstNameField.text;
       signup2VC.lastName = self.lastNameField.text;
       signup2VC.username = self.usernameField.text;
       signup2VC.password = self.passwordField.text;
        [self.navigationController pushViewController:signup2VC animated:YES];
    }
}


- (int) checkSignupErrors {
    //check name error
    if (self.firstNameField.text.length <2 ) {
        return FIRSTNAME_ERROR;
    }
    if (self.lastNameField.text.length<2) {
        return LASTNAME_ERROR;
    }
    
    //check password error
    BOOL containsLetter = NSNotFound != [self.passwordField.text rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location;
    BOOL containsNumber = NSNotFound != [self.passwordField.text rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet].location;
    if (self.passwordField.text.length < 6 ||
        !containsLetter ||
        !containsNumber) {
        return PASSWORD_ERROR;
    }
    
    //check username error
    
    return NO_ERROR;
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
