//
//  Ride.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Ride.h"
#import <Parse/Parse.h>

static const CLLocationDegrees empty = -1000;
static CLLocationCoordinate2D emptyCoordinates = {empty, empty};

@implementation Ride

-(id)init {
    return [self initWithDate:[NSDate date]];
}

- (id)initWithDate:(NSDate*) date {
    self = [super init];
    if (self) {
        self.dateTimeStart = date;
        self.startCordinate = emptyCoordinates;
        self.endCordinate = emptyCoordinates;
    }
    return self;
}

-(void)uploadToCloudWithBlock:(void (^) (BOOL, NSError*))block {
    PFObject *ride = [PFObject objectWithClassName:@"Offers"];
    
    // Creates PF geopoint for the start location, this can be querried
    PFGeoPoint *start = [PFGeoPoint geoPointWithLatitude:self.startCordinate.latitude
                                               longitude:self.startCordinate.longitude];
    ride[@"start"] = start;
    
    // Convert end double cordintes into NSnumber objects and store in array
    NSArray * end = [NSArray arrayWithObjects:[NSNumber numberWithDouble:self.endCordinate.latitude],
                     [NSNumber numberWithDouble:self.endCordinate.longitude], nil];
    ride[@"end"] = end;
    ride[@"dateTimeStart"] = self.dateTimeStart;
    [ride saveInBackgroundWithBlock:block];
}

@end
