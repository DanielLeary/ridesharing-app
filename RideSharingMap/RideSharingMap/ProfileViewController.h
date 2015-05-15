//
//  ProfileViewController.h
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "AppDelegate.h"
#import "AddPlaceViewController.h"
#import "EditProfileViewController.h"
#import "InterestsViewController.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EditProfileViewControllerDelegate>


// profile UI
@property (weak, nonatomic)   IBOutlet UILabel *interestsLabel;

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic)   IBOutlet UILabel *firstNameLabel;

@property (weak, nonatomic)   IBOutlet UILabel *lastNameLabel;

@property (weak, nonatomic)   IBOutlet UITableView *placesTableView;

@property (weak, nonatomic)   IBOutlet UILabel *pointsLabel;

@property (strong, nonatomic) IBOutlet UIButton *interestsButton;

@property (weak, nonatomic)   IBOutlet UIButton *addPlacesButton;


@end
