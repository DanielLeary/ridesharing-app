//
//  OfferRideTimeViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "OfferRideTimeViewController.h"
#import "OfferRideDestinationViewController.h"
#import "Ride.h"

@interface OfferRideTimeViewController ()
@property (strong)Ride* ride;
@end

@implementation OfferRideTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    // set minimum date to today
    NSDate * today = [NSDate date];
    self.ride = [[Ride alloc] initWithDate:today];
    [self.timeWheel setMinimumDate:today];
    
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
    if ([segue.identifier isEqualToString:@"OfferRideDestinationSeague"]) {
        OfferRideDestinationViewController *vc2 = (OfferRideDestinationViewController *)segue.destinationViewController;
        vc2.ride = self.ride;
        NSLog(@"Prepared for Seague");
    }
    
}
@end
