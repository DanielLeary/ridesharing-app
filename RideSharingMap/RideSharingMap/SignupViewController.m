//
//  SignupViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "SignupViewController.h"
#import "UserModel.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *model = [[UserModel alloc] init];
    self.viewModel = [[LoginViewModel alloc] initWithModel:model];
    
    signup_succ = false;
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
}*/


- (void)signup{
    int error = [self.viewModel sign_up:username.text :password.text :name.text :surname.text];
    NSString *error_text;
    switch (error) {
        case NO_ERROR:
            [self.viewModel inputFirstName:name.text];
            [self.viewModel inputSurname:surname.text];
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
    error_label.text = error_text;
    
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
}

@end
