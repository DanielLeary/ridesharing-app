//
//  SelectOfferViewController.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 13/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ride.h"

@interface SelectOfferViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property Ride* ride;

@end
