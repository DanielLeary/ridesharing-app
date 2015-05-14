//
//  Place.h
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Place : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic) NSString *zipcode;

- (id) initWithName:(NSString *)name;

- (id) initWithName:(NSString *)name andCoordinates:(CLLocationCoordinate2D)coordinates;

//return the latitude of a place
- (float) getLatitude;

//return the longitude of a place
- (float) getLongitude;

- (void) getPlacemarkFromCoordinates:(CLLocationCoordinate2D)coordinates;

@end
