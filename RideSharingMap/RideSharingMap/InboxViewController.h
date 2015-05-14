//
//  InboxViewController.h
//  RideSharingMap
//
//  Created by Daniel Leary on 26/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "InboxAccepted.h"
#import "InboxRequest.h"
#import "Journey.h"
#import <Parse/Parse.h>


@interface InboxViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
