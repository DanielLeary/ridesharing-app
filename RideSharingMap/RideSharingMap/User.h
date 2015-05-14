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
+ (void) clearInfo;


/* METHODS FOR USER INFO */
/* variable accessors */
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

//adds rmorePoints reward to the user points
- (void) addPoints:(NSUInteger)morePoints;


/* METHODS FOR FAV PLACES */

//return the number of favourite places
+ (NSUInteger) getFavPlacesCount;

//return favourite place at indexPath
+ (Place *) getPlaceAtIndex:(NSUInteger)indexPath;

//adds place to the end of the favourite places array
+ (void) addPlace:(Place *)place;

//replaces item at indexPath with the new favourite place
+ (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place;

//removes favourite place at indexPath from the favourite places array
+ (void) removePlaceAtIndex:(NSUInteger)indexPath;

//retrieves favourite plaes form the backend
+ (void) pullFavPlacesFromParse;


/* METHODS FOR INTERESTS */

//returns the number on interests saved
- (NSUInteger) getInterestsCount;

//return the array of interests
- (NSMutableArray *) getInterestsArray;

//returns true if interest is found in the interests array
- (bool) hasInterest:(NSString *)interest;

//updates the backend with newInterestArray
- (void) updateInterests:(NSArray *)newInterestArray;


/* METHODS FOR PROFILE PICTURE */

//return file data for the profile image
- (NSData*) getProfilePicture;

//sets profile image to profilePicture and saves it to the backend
- (void) setProfilePicture:(UIImage *)profilePicture;


@end
