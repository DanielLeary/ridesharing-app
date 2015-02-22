//
//  ProfileViewController.h
//  RideSharingMap
//
//  Created by Lach, Agata on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *ownedCar;
- (IBAction)editCar:(id)sender;

@end
