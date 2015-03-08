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

- (NSString *) getName {
    return self.name;
}

- (CLLocationCoordinate2D) getCoordinates {
    return self.coordinates;
}

- (float) getLatitude {
    return self.coordinates.latitude;
}

- (float) getLongitude {
    return self.coordinates.longitude;
}

- (NSString *) getZipCode {
    return self.zipcode;
}

/*
- (void) setPlacemark:(CLPlacemark *)placemark {
    //self.placemark = placemark;
    self.zipcode = [NSString stringWithFormat:@"%@", placemark.postalCode];
}*/

- (void) getPlacemarkFromCoordinates:(CLLocationCoordinate2D)coordinates {
    CLLocation *location = [[CLLocation alloc] initWithLatitude: coordinates.latitude longitude:coordinates.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //typeof(self) __weak weakSelf = self;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            NSLog(@"Geocode failed with error: %@", error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            //weakSelf.placemark = placemark;
            //[weakSelf setPlacemark:placemark];
            self.zipcode = [NSString stringWithFormat:@"%@", placemark.postalCode];
        }
    }];
}

@end
