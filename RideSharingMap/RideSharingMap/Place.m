//
//  Place.m
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Place.h"

static const CLLocationDegrees emptyCoord = -1000;
static const CLLocationCoordinate2D emptyCoords = {emptyCoord, emptyCoord};

@implementation Place

- (id) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.coordinates = emptyCoords;
        self.zipcode = @"";
    }
    return self;
}

- (id) initWithName:(NSString *)name andCoordinates:(CLLocationCoordinate2D)coordinates {
    self = [super init];
    if (self) {
        self.name = name;
        self.coordinates = coordinates;
        [self getPlacemarkFromCoordinates:coordinates];
    }
    return self;
}

- (float) getLatitude {
    return self.coordinates.latitude;
}

- (float) getLongitude {
    return self.coordinates.longitude;
}

- (void) getPlacemarkFromCoordinates:(CLLocationCoordinate2D)coordinates {
    CLLocation *location = [[CLLocation alloc] initWithLatitude: coordinates.latitude longitude:coordinates.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            NSLog(@"Geocode failed with error: %@", error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            self.zipcode = [NSString stringWithFormat:@"%@", placemark.postalCode];
        }
    }];
}

@end
