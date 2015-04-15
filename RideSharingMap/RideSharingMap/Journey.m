//
//  Journey.m
//  RideSharingMap
//
//  Created by Daniel Leary on 15/04/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Journey.h"
#import <Parse/Parse.h>

@implementation Journey

-(id)init {
    self = [super init];
    if (self) {
        CLLocationCoordinate2D emptyCoordinates = {0, 0};
        self.journeyDateTime = [NSDate date];
        self.startCoordinate = emptyCoordinates;
        self.endCoordinate = emptyCoordinates;
        self.pickupCoordinate = emptyCoordinates;
    }
    return self;
}

-(BOOL) uploadToCloud {
    
    PFObject *journey = [PFObject objectWithClassName:@"Journeys"];
    
    NSArray * start = [NSArray arrayWithObjects:[NSNumber numberWithDouble:self.startCoordinate.latitude],
                     [NSNumber numberWithDouble:self.startCoordinate.longitude], nil];
    journey[@"start"] = start;
    
    NSArray * end = [NSArray arrayWithObjects:[NSNumber numberWithDouble:self.endCoordinate.latitude],
                       [NSNumber numberWithDouble:self.endCoordinate.longitude], nil];
    journey[@"end"] = end;
    
    NSArray * pickup = [NSArray arrayWithObjects:[NSNumber numberWithDouble:self.pickupCoordinate.latitude],
                       [NSNumber numberWithDouble:self.pickupCoordinate.longitude], nil];
    journey[@"pickup"] = pickup;
    
    journey[@"journeyDateTime"] = self.journeyDateTime;
    
    journey[@"driverEmail"] = self.driverEmail;
    
    journey[@"passengerEmail"] = self.passengerEmail;
    
    [journey saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            NSLog(@"saved journey");
        } else {
            NSLog(@"journey save failed");
        }
    }];

    return true;
}


@end
