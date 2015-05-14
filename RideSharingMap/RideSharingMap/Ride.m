//
//  Ride.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Ride.h"
#import "userDefines.h"


static const CLLocationDegrees empty = -1000;
static CLLocationCoordinate2D emptyCoordinates = {empty, empty};

@implementation Ride

+ (double)distanceBetweenCoordinates:(CLLocationCoordinate2D)one secondCordinate:(CLLocationCoordinate2D)two {
    CLLocation* location1 = [[CLLocation alloc] initWithLatitude:one.latitude longitude:one.longitude];
    CLLocation* location2 = [[CLLocation alloc] initWithLatitude:two.latitude longitude:two.longitude];
    
    
    
    // get distances in meters and convert to KM by dividing by 1000
    double distance = [location1 distanceFromLocation:location2]/1000;
    
    // Convert distances into miles
    distance *= 0.6213711;
    
    return distance;
}

-(id)init {
    return [self initWithDate:[NSDate date]];
}

- (id)initWithDate:(NSDate*) date {
    self = [super init];
    if (self) {
        self.dateTimeStart = date;
        self.startCordinate = emptyCoordinates;
        self.endCordinate = emptyCoordinates;
        self.offerRide = false;
    }
    return self;
}

-(void)uploadToCloudWithBlock:(void (^) (bool, NSError*))block {
    PFObject *ride = [PFObject objectWithClassName:OFFER];
    
    // Creates PF geopoint for the start location, this can be querried
    PFGeoPoint *start = [PFGeoPoint geoPointWithLatitude:self.startCordinate.latitude
                                               longitude:self.startCordinate.longitude];
    ride[O_STARTPOS] = start;
    
    // Convert end double cordintes into NSnumber objects
    NSNumber* lat = [self formatTo4dp:self.endCordinate.latitude];
    NSNumber* lon = [self formatTo4dp:self.endCordinate.longitude];

    ride[O_ENDLAT] = lat;
    ride[O_ENDLONG] = lon;
    ride[O_TIME] = self.dateTimeStart;
    ride[O_DRIVER] = self.user;
    
    [ride saveInBackgroundWithBlock:block];
}


-(void)offerRideToCloudWithBlock:(void (^) (BOOL, NSError*))block {
    PFObject *offer = [PFObject objectWithClassName:REQUEST];
    NSLog(@"date time : %@", self.dateTimeStart);
    offer[R_PICKUPTIME] = self.dateTimeStart;
    offer[R_START] = [PFGeoPoint geoPointWithLatitude:self.startCordinate.latitude longitude:self.startCordinate.longitude];
    NSNumber* endLat = [NSNumber numberWithDouble:self.endCordinate.latitude];
    NSNumber* endLong = [NSNumber numberWithDouble:self.endCordinate.longitude];
    
    offer[R_END] = [NSArray arrayWithObjects:endLat, endLong, nil];
    offer[R_PASSENGER] = self.user;
    offer[R_DRIVER] = self.drivers[self.rowNumber];
    offer[R_OFFER] = self.rideOffers[self.rowNumber];
    
    [offer saveInBackgroundWithBlock:block];
}


// Queries Offers that match start and end coordinates within a 15 minute time frame
- (void)queryRidesWithBlock:(void (^)(bool, NSError*))block {
    PFGeoPoint* start = [PFGeoPoint geoPointWithLatitude:self.startCordinate.latitude longitude:self.startCordinate.longitude];
    PFQuery* query = [PFQuery queryWithClassName:OFFER];
    
    // Search for Offers that are within 0.2 Miles of Pickup point
    [query whereKey:@"start" nearGeoPoint:start withinMiles:2];
    NSNumber* UPPERlat = [self formatTo4dp:(self.endCordinate.latitude + DISTANCEEPSILON)];
    NSNumber* LOWERlat = [self formatTo4dp:(self.endCordinate.latitude - DISTANCEEPSILON)];
    NSNumber* UPPERlon = [self formatTo4dp:(self.endCordinate.longitude + DISTANCEEPSILON)];
    NSNumber* LOWERlon = [self formatTo4dp:(self.endCordinate.longitude - DISTANCEEPSILON)];
    NSLog(@"end UPPERlatitude: %@", UPPERlat);
    NSLog(@"end LOWERlatitude: %@", LOWERlat);
    NSLog(@"end UPPERlongitude: %@", UPPERlon);
    NSLog(@"end LOWERlongitude: %@", LOWERlon);
    
    NSDate* UPPERdate = [[NSDate alloc] initWithTimeInterval:TIMEEPSILON sinceDate:self.dateTimeStart];
    NSDate* LOWERdate = [[NSDate alloc] initWithTimeInterval:-TIMEEPSILON sinceDate:self.dateTimeStart];
    
    // Query where locations are within a 0.0005 2d cordinate of destination in both
    // Latitude and longitude
    [query whereKey:O_ENDLAT greaterThanOrEqualTo:LOWERlat];
    [query whereKey:O_ENDLAT lessThanOrEqualTo:UPPERlat];
    
    [query whereKey:O_ENDLONG greaterThanOrEqualTo:LOWERlon];
    [query whereKey:O_ENDLONG lessThanOrEqualTo:UPPERlon];
    
    // Need to find adequate times
    [query whereKey:O_TIME greaterThanOrEqualTo:LOWERdate];
    [query whereKey:O_TIME lessThanOrEqualTo:UPPERdate];
    
    // also download user object info
    [query includeKey:@"driver"];
    
    // Limit results of query to 10
    query.limit = 10;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError *error) {
        
        //If query returns no results then display to user
        NSLog(@"Number of returned values: %lu", [objects count]);
        if([objects count] == 0) {
            block(FALSE, error);
        }
        
        // Initialize arrays to hold drivers and rideOffers
        self.drivers = [[NSMutableArray alloc] init];
        self.rideOffers = [[NSArray alloc] initWithArray:objects];
        
        for (PFObject* object in objects) {
            [self.drivers addObject:[object objectForKey:@"driver"]];
        }
        
        block(TRUE, error);
    }];
}

// Converts double to NSNumber with 4dp precision
- (NSNumber*)formatTo4dp:(double) convertme {
    NSString* formattedStr = [NSString stringWithFormat:@"%.04f", convertme];
    NSNumberFormatter *convert = [[NSNumberFormatter alloc] init];
    return [convert numberFromString:formattedStr];
}

@end
