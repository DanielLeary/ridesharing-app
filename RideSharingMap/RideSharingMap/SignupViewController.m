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

}


- (void)viewDidLoad {
    [super viewDidLoad];
    inputError = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.firstNameField becomeFirstResponder];
    _passwordField.secureTextEntry = YES;
}


/* METHODS FOR UI */

- (IBAction)nextPressed:(UIButton *)sender {
    [self resetTextFields];
    NSString *errorText;
    int error = [self checkSignupErrors];

    switch (error) {
        case NO_ERROR:
            inputError = NO;
            break;
        case FIRSTNAME_ERROR:
            inputError = YES;
            errorText = @"First name must be more than 2 letters.";
            self.firstNameField.layer.borderColor  = [[UIColor redColor] CGColor];
            self.firstNameField.layer.borderWidth  = 1;
            self.firstNameField.layer.cornerRadius = 5;
            break;
        case LASTNAME_ERROR:
            inputError = YES;
            errorText = @"Last name must be more than 2 letters.";
            self.lastNameField.layer.borderColor  = [[UIColor redColor] CGColor];
            self.lastNameField.layer.borderWidth  = 1;
            self.lastNameField.layer.cornerRadius = 5;
            break;
        case USERNAME1_ERROR:
            inputError = YES;
            errorText = @"Username must be at least 2 letters.";
            self.usernameField.layer.borderColor  = [[UIColor redColor] CGColor];
            self.usernameField.layer.borderWidth  = 1;
            self.usernameField.layer.cornerRadius = 5;
            break;
        case USERNAME2_ERROR:
            inputError = YES;
            errorText = @"Username already in use. Please choose another.";
            self.usernameField.layer.borderColor  = [[UIColor redColor] CGColor];
            self.usernameField.layer.borderWidth  = 1;
            self.usernameField.layer.cornerRadius = 5;
            break;
        case PASSWORD_ERROR:
            inputError = YES;
            errorText = @"Password must contain at least 1 letter and 1 number, and be at least 6 characters.";
            self.passwordField.layer.borderColor  = [[UIColor redColor] CGColor];
            self.passwordField.layer.borderWidth  = 1;
            self.passwordField.layer.cornerRadius = 5;
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
       signup2VC.lastName  = self.lastNameField.text;
       signup2VC.username  = self.usernameField.text;
       signup2VC.password  = self.passwordField.text;
        [self.navigationController pushViewController:signup2VC animated:YES];
    }
}


- (int) checkSignupErrors {
    //check name error
    if (self.firstNameField.text.length <MIN_NAME_LEN ) {
        return FIRSTNAME_ERROR;
    }
    if (self.lastNameField.text.length<MIN_NAME_LEN) {
        return LASTNAME_ERROR;
    }
    
    //check password error
    BOOL containsLetter = NSNotFound != [self.passwordField.text rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location;
    BOOL containsNumber = NSNotFound != [self.passwordField.text rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet].location;
    if (self.passwordField.text.length < MIN_PASS_LEN ||
        !containsLetter ||
        !containsNumber) {
        return PASSWORD_ERROR;
    }
    
    //check username error
    if (self.usernameField.text.length < MIN_NAME_LEN) {
        return USERNAME1_ERROR;
    }
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.usernameField.text];
    NSArray *results = [query findObjects];
    if ([results count] != 0) {
        return USERNAME2_ERROR;
    }
    
    return NO_ERROR;
}

- (void) resetTextFields {
    self.firstNameField.layer.borderWidth = 0;
    self.lastNameField.layer.borderWidth  = 0;
    self.usernameField.layer.borderWidth  = 0;
    self.passwordField.layer.borderWidth  = 0;
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
