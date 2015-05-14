//
//  DashboardViewController.h
//  RideSharingMap
//
//  Created by Daniel Leary on 26/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "GivingRideCell.h"
#import "GettingRideCell.h"
#import "Journey.h"
#import "JourneyView.h"
#import "userDefines.h"
#import "User.h"

@interface DashboardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
