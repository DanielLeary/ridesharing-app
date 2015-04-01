//
//  DashboardViewController.h
//  RideSharingMap
//
//  Created by Daniel Leary on 26/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController
@property NSMutableArray *tableData;
@property NSMutableArray *itemTypes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
