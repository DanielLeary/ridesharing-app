//
//  InitialViewController.m
//  RideSharingMap
//
//  Created by Lach, Agata on 25/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ViewDidLoad");
    currentUser = [PFUser currentUser];
    if (currentUser) {
        
        [logLabel setText:currentUser.username];
        // do stuff with the user
    } else {
        [logLabel setText:@"Logged out"];
        // show the signup or login screen
    }
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"ViewDidAppear");
    currentUser = [PFUser currentUser];
    if (currentUser) {
        
        [logLabel setText:currentUser.username];
        // do stuff with the user
    } else {
        [logLabel setText:@"Logged out"];
        // show the signup or login screen
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    currentUser = [PFUser currentUser]; // this will now be nil
    [logLabel setText:@"Logged out"];

}
@end
