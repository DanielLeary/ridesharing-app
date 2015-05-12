//
//  Ride.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Ride.h"
#import <Parse/Parse.h>

#define JOURNEY @"Offers"
#define STARTPOS @"start"
#define ENDLAT @"endLat"
#define ENDLONG @"endLong"
#define TIME @"dateTimeStart"
#define TIMEEPSILON 900


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
        self.offerRide = false    ;
    }
    return self;
}

-(void)uploadToCloudWithBlock:(void (^) (BOOL, NSError*))block {
    PFObject *ride = [PFObject objectWithClassName:JOURNEY];
    
    // Creates PF geopoint for the start location, this can be querried
    PFGeoPoint *start = [PFGeoPoint geoPointWithLatitude:self.startCordinate.latitude
                                               longitude:self.startCordinate.longitude];
    ride[STARTPOS] = start;
    
    // Convert end double cordintes into NSnumber objects and store in array
    NSNumber* lat = [self formatTo4dp:self.endCordinate.latitude];
    NSNumber* lon = [self formatTo4dp:self.endCordinate.longitude];
    //NSArray * end = [NSArray arrayWithObjects:lat, lon, nil];
    ride[ENDLAT] = lat;
    ride[ENDLONG] = lon;
    ride[TIME] = self.dateTimeStart;
    [ride saveInBackgroundWithBlock:block];
}

- (void)queryRidesWithBlock:(void (^)(bool, NSError*))block {
    PFGeoPoint* start = [PFGeoPoint geoPointWithLatitude:self.startCordinate.latitude longitude:self.startCordinate.longitude];
    PFQuery* query = [PFQuery queryWithClassName:JOURNEY];
    
    // Search for Offers that are within 0.2 Miles of Pickup point
    [query whereKey:@"start" nearGeoPoint:start withinMiles:2];
    NSNumber* UPPERlat = [self formatTo4dp:(self.endCordinate.latitude + 0.004)];
    NSNumber* LOWERlat = [self formatTo4dp:(self.endCordinate.latitude - 0.004)];
    NSNumber* UPPERlon = [self formatTo4dp:(self.endCordinate.longitude + 0.004)];
    NSNumber* LOWERlon = [self formatTo4dp:(self.endCordinate.longitude - 0.004)];
    NSLog(@"end UPPERlatitude: %@", UPPERlat);
    NSLog(@"end LOWERlatitude: %@", LOWERlat);
    NSLog(@"end UPPERlongitude: %@", UPPERlon);
    NSLog(@"end LOWERlongitude: %@", LOWERlon);
    
    NSDate* UPPERdate = [[NSDate alloc] initWithTimeInterval:TIMEEPSILON sinceDate:self.dateTimeStart];
    NSDate* LOWERdate = [[NSDate alloc] initWithTimeInterval:-TIMEEPSILON sinceDate:self.dateTimeStart];
    
    // Query where locations are within a 0.0005 2d cordinate of destination in both
    // Latitude and longitude
    [query whereKey:ENDLAT greaterThanOrEqualTo:LOWERlat];
    [query whereKey:ENDLAT lessThanOrEqualTo:UPPERlat];
    
    [query whereKey:ENDLONG greaterThanOrEqualTo:LOWERlon];
    [query whereKey:ENDLONG lessThanOrEqualTo:UPPERlon];
    
    // Need to find adequate times
    [query whereKey:TIME greaterThanOrEqualTo:LOWERdate];
    [query whereKey:TIME lessThanOrEqualTo:UPPERdate];
    
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

// Converts double to NSNumber with 4dp precision
- (NSNumber*)formatTo4dp:(double) convertme {
    NSString* formattedStr = [NSString stringWithFormat:@"%.04f", convertme];
    NSNumberFormatter *convert = [[NSNumberFormatter alloc] init];
    return [convert numberFromString:formattedStr];
}

@end
