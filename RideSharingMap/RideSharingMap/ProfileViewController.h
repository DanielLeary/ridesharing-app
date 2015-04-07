//
//  ProfileViewController.h
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPlaceViewController.h"
#import "EditProfileViewController.h"
#import "InterestsViewController.h"
#import "ProfileViewModel.h"

@class ProfileViewModel;

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddPlaceViewControllerDelegate>


// profile UI

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UILabel *surname_label;

@property (weak, nonatomic) IBOutlet UITableView *placesTableView;

@property (weak, nonatomic) IBOutlet UILabel *numRidesLabel;

@property (strong, nonatomic) IBOutlet UIButton *interestsButton;



// table UI

@property (weak, nonatomic) IBOutlet UIButton *editPlacesButton;

@property (weak, nonatomic) IBOutlet UIButton *addNewPlaceButton;


- (IBAction)inputCar:(id)sender;

@end
