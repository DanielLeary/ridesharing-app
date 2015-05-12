//
//  UserViewModel.h
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Parse/Parse.h>
#import "UserModel.h"
#import "Place.h"

#define NO_ERROR 0
#define FIRSTNAME_ERROR 1
#define LASTNAME_ERROR 2
#define EMAIL_ERROR 3
#define PASSWORD_ERROR 4


@interface UserViewModel : NSObject


/* INIT METHOD */

- (instancetype) initWithModel:(UserModel *)user;


/* METHODS FOR BASIC INFO */

- (void)updateParseUser;

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

/* METHODS FOR FAV PLACES */

- (NSUInteger) getFavPlacesCount;

- (Place *) getPlaceAtIndex:(NSUInteger)indexPath;

- (void) addPlace:(Place *)place;

- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath;

- (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place;

- (void) removePlaceAtIndex:(NSUInteger)indexPath;

-(void) pullPlacesArray;


/* METHODS FOR INTERESTS */

- (NSUInteger)getInterestsCount;

- (NSMutableArray *)getInterestsArray;

- (bool)hasInterest:(NSString *)interest;

- (void)updateInterests:(NSArray *)newInterestsArray;


/* METHODS FOR PROFILE PICTURE */

- (UIImage *)getProfilePicture;

- (void)setProfilePicture:(UIImage *)image;

-(NSData*) getPicture;



/* METHODS FOR LOGIN & SIGNUP */

- (void)logOut;

- (BOOL)loginwithEmail:(NSString*)email andPassword:(NSString *)password;

- (int)checkSignupErrorsForFirstName:(NSString *)firstName andLastName:(NSString *)lastName andPassword:(NSString *)password;

- (int)signupWithEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName andLastName:(NSString *)lastName;


/* METHODS FOR GEOCODING */

+ (NSString *)getZipCodeFromPlacemark:(CLPlacemark *)placemark;


@end
