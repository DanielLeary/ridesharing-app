//
//  Ride.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Ride : NSObject

@property CLLocationCoordinate2D startCordinate;
@property CLLocationCoordinate2D endCordinate;
@property (strong) NSDate * dateTimeStart;
@property BOOL offerRide;
@property NSArray* rideOffers;

- (id)initWithDate:(NSDate*) date;
- (void)uploadToCloudWithBlock:(void (^) (BOOL, NSError*))block;
- (void)queryRidesWithBlock:(void (^)(BOOL, NSError*))block;

@end
