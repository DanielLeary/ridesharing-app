//
//  UserViewModel.h
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "UserModel.h"

#define NO_ERROR 0
#define FIRSTNAME_ERROR 1
#define LASTNAME_ERROR 2
#define EMAIL_ERROR 3
#define PASSWORD_ERROR 4


@interface UserViewModel : NSObject

/* INIT METHOD */

//- (instancetype) initWithModel:(UserModel *)user;


/* METHODS FOR BASIC INFO */

/* updates basic data for the user */
//- (void)updateParseUser;

/* accessors for user data */

/*
- (NSString *)getFirstName;

- (void) setFirstName:(NSString *)firstName;

- (NSString *)getLastName;

- (void) setLastName:(NSString *)lastName;

- (NSString *)getUsername;

- (NSString *)getPassword;

- (NSDate *)getDob;

- (void) setDob:(NSDate *)dob;

- (NSString *)getDobString;

- (NSString *)getAge;

- (NSString *)getGender;
*/

/* METHODS FOR FAV PLACES */

/* 
 These methods propagate calls from the View Controllers to the UserModel
 See method descriptions in UserModel.h 
 */

/*
- (NSUInteger) getFavPlacesCount;

- (Place *) getPlaceAtIndex:(NSUInteger)indexPath;

- (void) addPlace:(Place *)place;

- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath;

- (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place;

- (void) removePlaceAtIndex:(NSUInteger)indexPath;

- (void) pullPlacesArray;
*/

/* METHODS FOR INTERESTS */
/* 
 These methods propagate calls from the View Controllers to the UserModel
 See method descriptions in UserModel.h 
 */

/*
- (NSMutableArray *)getInterestsArray;

- (bool)hasInterest:(NSString *)interest;

- (void)updateInterests:(NSArray *)newInterestsArray;
*/

/* METHODS FOR PROFILE PICTURE */
/* 
 These methods propagate calls from the View Controllers to the UserModel
   See method descriptions in UserModel.h 
 */
/*
- (UIImage *)getProfilePicture;

- (void)setProfilePicture:(UIImage *)image;

- (NSData*) getPicture;
*/

/* METHODS FOR LOGIN & SIGNUP */

/*
- (int)signupWithEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName andLastName:(NSString *)lastName;
*/

@end
