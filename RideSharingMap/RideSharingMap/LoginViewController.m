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
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
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

- (IBAction)log_in:(id)sender {
    PFUser *user = [PFUser user];
    user.username = usernameField.text;
    user.password = passwordField.text;
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
        }
    }];
}

- (IBAction)input_user:(id)sender {
}

- (IBAction)input_password:(id)sender {
}
@end
