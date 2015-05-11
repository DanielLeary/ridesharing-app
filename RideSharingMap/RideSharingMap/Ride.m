//
//  Ride.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Ride.h"
#import <Parse/Parse.h>

#define journe

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
        self.offerRide = nil;
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

- (void)queryRidesWithBlock:(void (^)(bool, NSError*))block {
    PFGeoPoint* start = [PFGeoPoint geoPointWithLatitude:self.startCordinate.latitude longitude:self.startCordinate.longitude];
    PFQuery* query = [PFQuery queryWithClassName:@"Offers"];
    
    // Search for Offers that are within 0.2 Miles of Pickup point
    [query whereKey:@"start" nearGeoPoint:start withinMiles:0.2];
    NSNumber* endLatitude = [NSNumber numberWithFloat:self.endCordinate.latitude];
    NSNumber* endLongitude = [NSNumber numberWithFloat:self.endCordinate.longitude];
    [query whereKey:@"end" containsAllObjectsInArray:@[endLatitude, endLongitude]];
    
    // Limit results of query to 10
    query.limit = 10;
    
    // Run query
    [query findObjectsInBackgroundWithBlock:^(NSArray* array, NSError* error) {
        // issues with saving to background, should be delt with here
        if (error) {
            block(false, error);
        } else {
            // Assign returned array to ride offers
            self.rideOffers = array;
            block(true, nil);
        }
    }];
}

@end
