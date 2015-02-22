//
//  ProfileViewController.m
//  RideSharingMap
//
//  Created by Lach, Agata on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFQuery *query = [PFQuery queryWithClassName:@"ownedCar"];
    [query getObjectInBackgroundWithId:@"7307SX8bWz" block:^(PFObject *ownedCar, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        
    }];
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

- (IBAction)editCar:(id)sender {
    if (self.ownedCar.text.length > 0){
        PFObject *ownedCar = [PFObject objectWithClassName:@"ownedCar"];
        ownedCar[@"ownedCar"] = self.ownedCar.text;
        [ownedCar saveInBackground];
    }
}
@end
