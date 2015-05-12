//
//  OfferRideTimeViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "OfferRideTimeViewController.h"
#import "OfferRideStartViewController.h"
#import "Ride.h"

@interface OfferRideTimeViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *NavTitle;


@end

@implementation OfferRideTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    //If Offering a ride
    if (self.ride.offerRide) {
        self.NavTitle.title = @"Offer Ride";
    } else {
        self.NavTitle.title = @"Request Ride";
    }
    
    // set minimum date to today
    [self.timeWheel setMinimumDate:self.ride.dateTimeStart];
    
    // Everytime wheel changes (UIControlEventValueChanged) runs the method printChange
    [self.timeWheel addTarget:self action:@selector(printChange) forControlEvents:UIControlEventValueChanged];
}

-(void)printChange {
    NSLog(@"time modified");
    [self.ride setDateTimeStart:self.timeWheel.date];
    //NSLog(self.timeWheel.date);

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OfferRideStartSeague"]) {
        OfferRideStartViewController *vc2 = (OfferRideStartViewController *)segue.destinationViewController;
        vc2.ride = self.ride;
        NSLog(@"Prepared for Seague");
    }
    
}
@end
