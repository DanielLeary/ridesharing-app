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
//@property (strong, nonatomic) CLPlacemark *placemark;
@property (nonatomic) NSString *zipcode;

- (id) initWithName:(NSString *)name;

- (id) initWithName:(NSString *)name andCoordinates:(CLLocationCoordinate2D)coordinates;

- (float) getLatitude;

- (float) getLongitude;

- (void) getPlacemarkFromCoordinates:(CLLocationCoordinate2D)coordinates;

@end
