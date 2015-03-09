//
//  LoginViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 24/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "UserModel.h"


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
    UserModel *model = [[UserModel alloc] init];
    self.viewModel = [[LoginViewModel alloc] initWithModel:model];
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
    [self.viewModel inputFirstName:firstname_field.text];
}

- (IBAction)input_surname:(id)sender {
    [self.viewModel inputSurname:surname_field.text];
}

- (IBAction)log_in:(id)sender {
    if([self.viewModel log_in:usernameField.text :passwordField.text])
        [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)input_user:(id)sender {
}

- (IBAction)input_password:(id)sender {
}

- (IBAction)sign_up:(id)sender {
    //TODO deal with different types of errors
    int error = [self.viewModel sign_up:usernameField.text :passwordField.text];
    NSString *error_text;
    switch (error) {
        case NO_ERROR:
            error_text = @"Sign up was successfull";
            break;
        case NAME_ERROR:
            error_text = @"Incorrect Name, signup unsuccessful";
            break;
        case SURNAME_ERROR:
            error_text = @"Incorrect Surname, signup unsiccessful";
            break;
        case USERNAME_ERROR:
            error_text = @"Username already in use. Please choose another uesrname";
            break;
        case PASSWORD_ERROR:
            error_text = @"Password must contain at least one letter and nmber, and be at least 6 characters long";
        
        default:
            break;
    }
    error_label.text = error_text;
}
@end
