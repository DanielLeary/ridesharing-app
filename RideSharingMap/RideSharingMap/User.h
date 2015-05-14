//
//  User.h
//  RideSharingMap
//
//  Created by Lin Han on 13/5/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Parse/Parse.h>
#import "userDefines.h"
#import "Place.h"

@interface User : PFUser <PFSubclassing>

+ (User *)user;
+ (User *)currentUser;

+ (void) pullFromParse;


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

- (NSString *) getPointsString;

- (void) addPoints:(NSUInteger)morePoints;


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
