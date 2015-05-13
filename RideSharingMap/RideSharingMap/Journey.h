//
//  Journey.h
//  RideSharingMap
//
//  Created by Daniel Leary on 15/04/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Journey : NSObject

@property CLLocationCoordinate2D startCoordinate;
@property CLLocationCoordinate2D endCoordinate;
@property CLLocationCoordinate2D pickupCoordinate;
@property (strong) NSDate * journeyDateTime;
@property (nonatomic) NSString * driverusername;
@property (nonatomic) NSString * passengerusername;

- (BOOL)uploadToCloud;


@end
