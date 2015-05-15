//
//  OfferRideTimeViewController.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "OfferRideStartViewController.h"


@interface OfferRideTimeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *timeWheel;
@property (strong)Ride* ride;

@end
