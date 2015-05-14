//
//  RequestRideCell.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 13/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestRideCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *driver;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *profile;

@end
