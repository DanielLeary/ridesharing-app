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

@property NSString *name;
@property CLLocationCoordinate2D *coordinates;

- (id) initWithName:(NSString *)name;
- (id) initWithName:(NSString *)name andCoordinates:(CLLocationCoordinate2D *)coordinates;
- (NSString *) getName;
- (CLLocationCoordinate2D *) getCoordinates;
- (float) getLatitude;
- (float) getLongitude;

@end
