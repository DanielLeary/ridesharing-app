//
//  LoginNewViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "LoginNewViewController.h"
#import "UserModel.h"


@interface LoginNewViewController ()

@end

@implementation LoginNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserModel *model = [[UserModel alloc] init];
    self.viewModel = [[LoginViewModel alloc] initWithModel:model];
    // Do any additional setup after loading the view.
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
- (IBAction)backToLoginView:(UIStoryboardSegue *)segue
{
    //necessary action to retrieve this view when sign-up is completed in the signup view
}

- (IBAction)login:(id)sender {
    if (![self.viewModel log_in:username.text :password.text])
        error_label.text = @"Incorrect login details";
    else
        error_label.text = @"Logged in successfully";
}
@end
