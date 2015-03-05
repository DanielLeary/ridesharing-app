//
//  ProfileViewController.h
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPlaceViewController.h"
#import "ProfileViewModel.h"

@class ProfileViewModel;

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddPlaceViewControllerDelegate>

// profileViewModel instance

@property (strong, nonatomic) ProfileViewModel *profileViewModel;

// profile UI

@property (weak, nonatomic) IBOutlet UILabel *username_label;

@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UILabel *surname_label;

@property (weak, nonatomic) IBOutlet UITableView *placesTableView;

@property (weak, nonatomic) IBOutlet UITextField *carField;

// table UI

@property (weak, nonatomic) IBOutlet UIButton *editPlacesButton;

@property (weak, nonatomic) IBOutlet UIButton *addNewPlaceButton;



- (IBAction)inputCar:(id)sender;

@end
