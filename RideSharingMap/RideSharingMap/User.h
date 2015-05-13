//
//  User.h
//  RideSharingMap
//
//  Created by Lin Han on 13/5/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Place.h"

#define Pfirstname @"Name"
#define Plastname @"Surname"
#define Pcar @"Car"
#define Pposition @"Position"
#define Pusername @"username"
#define Pdob @"dob"
#define Pgender @"Gender"
#define Ppicture @"ProfilePicture"
#define Pinterests @"Interests"
#define Pfavplaces @"FavPlaces"
#define Ppassword @"password"


@interface User : PFUser <PFSubclassing>

//+ (User *)user;
+ (User *)currentUser;

//+ (NSString *)parseClassName;


/* METHODS FOR USER INFO */

- (NSString *)getFirstName;

- (void) setFirstName:(NSString *)firstName;

- (NSString *)getLastName;

- (void) setLastName:(NSString *)lastName;

- (NSString *)getUsername;

- (NSString *)getPassword;

- (NSDate *)getDob;

- (void) setDob:(NSDate *)newDob;

- (NSString *)getDobString;

- (NSString *)getAge;

- (NSString *)getGender;

- (void) setGender:(NSString *)newGender;


/* METHODS FOR FAV PLACES */

+ (NSUInteger) getFavPlacesCount;

+ (Place *) getPlaceAtIndex:(NSUInteger)indexPath;

+ (void) addPlace:(Place *)place;

+ (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place;

+ (void) removePlaceAtIndex:(NSUInteger)indexPath;

+ (void) pullFavPlacesFromParse;


/* METHODS FOR INTERESTS */

- (NSUInteger) getInterestsCount;

- (NSMutableArray *) getInterestsArray;

- (bool) hasInterest:(NSString *)interest;

- (void) updateInterests:(NSArray *)newInterestArray;


/* METHODS FOR PROFILE PICTURE */

- (NSData*) getProfilePicture;

- (void) setProfilePicture:(UIImage *)profilePicture;


@end
