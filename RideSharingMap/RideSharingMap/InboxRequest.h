//
//  InboxRequest.h
//  RideSharingMap
//
//  Created by Daniel Leary on 15/04/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxRequest : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *acceptbutton;
@property (weak, nonatomic) IBOutlet UIButton *declinebutton;

@end
