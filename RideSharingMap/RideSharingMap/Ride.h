//
//  Ride.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface Ride : NSObject

@property CLLocationCoordinate2D startCordinate;
@property CLLocationCoordinate2D endCordinate;
@property NSDate * dateTimeStart;
@property BOOL offerRide;
@property NSArray* rideOffers;
@property NSMutableArray* drivers;
@property PFUser* user;
@property int rowNumber;


// Takes two CLLocationCoordinates and returns value of distance between them in miles
+ (double)distanceBetweenCoordinates:(CLLocationCoordinate2D)one secondCordinate:(CLLocationCoordinate2D)two;
- (id)initWithDate:(NSDate*) date;

// Submites an offer to the cloud from the user
- (void)uploadToCloudWithBlock:(void (^) (bool, NSError*))block;

// Querys Rides which will be leaving at the same time (plus or minus 15 mins)
// From same location (distance of 2 miles) to the same destination (distance of ~2 miles)
// Function automatically updates rideOffers and drivers based on query
- (void)queryRidesWithBlock:(void (^)(bool, NSError*))block;

@end
