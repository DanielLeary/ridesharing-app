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
#import "userDefines.h"

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

// Initializer with date
- (id)initWithDate:(NSDate*) date;

// Initialises ride object with Current date and time as date value
-(id)init;

// Submites an offer to the cloud from the user
- (void)uploadToCloudWithBlock:(void (^) (bool, NSError*))block;

// Querys Rides which will be leaving at the same time (plus or minus 15 mins)
// From same location (distance of 2 miles) to the same destination (distance of ~2 miles)
// Function automatically updates rideOffers and drivers arrays based on query for use in view controllers
- (void)queryRidesWithBlock:(void (^)(bool, NSError*))block;

// Uploads an offer of a ride into cloud
-(void)offerRideToCloudWithBlock:(void (^) (BOOL, NSError*))block;


@end
