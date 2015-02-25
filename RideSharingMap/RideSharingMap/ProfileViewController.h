//
//  ProfileViewController.h
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPlaceViewController.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddPlaceViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UITableView *placesTableView;
@property (weak, nonatomic) IBOutlet UITextField *carField;

@property (weak, nonatomic) IBOutlet UIButton *editPlacesButton;

@property (weak, nonatomic) IBOutlet UIButton *addNewPlaceButton;
- (IBAction)inputCar:(id)sender;



@end
