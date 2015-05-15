//
//  InterestsViewController.h
//  RideSharingMap
//
//  Created by Lin Han on 2/4/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "User.h"

@interface InterestsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *interestsTableView;

@property User *user;
@property BOOL fromSingup;
@end
