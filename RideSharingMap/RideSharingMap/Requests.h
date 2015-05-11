//
//  Request.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 17/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Requests : NSObject

@property CLLocationCoordinate2D startCordinate;
@property CLLocationCoordinate2D endCordinate;
@property (strong) NSDate * dateTimeStart;

- (id)initWithDate:(NSDate*) date;
- (void)uploadToCloudWithBlock:(void (^) (BOOL, NSError*))block;

@end
