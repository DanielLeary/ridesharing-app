//
//  Request.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Requests.h"
#import <Parse/Parse.h>

static const CLLocationDegrees empty = -1000;
static CLLocationCoordinate2D emptyCoordinates = {empty, empty};

@implementation Requests

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
    PFObject *request = [PFObject objectWithClassName:@"Requests"];
    
    // Creates PF geopoint for the start location, this can be querried
    PFGeoPoint *start = [PFGeoPoint geoPointWithLatitude:self.startCordinate.latitude
                                               longitude:self.startCordinate.longitude];
    request[@"start"] = start;
    
    // Convert end double cordintes into NSnumber objects and store in array
    NSArray * end = [NSArray arrayWithObjects:[NSNumber numberWithDouble:self.endCordinate.latitude],
                     [NSNumber numberWithDouble:self.endCordinate.longitude], nil];
    request[@"end"] = end;
    request[@"dateTimeStart"] = self.dateTimeStart;
    [request saveInBackgroundWithBlock:block];
}

@end
