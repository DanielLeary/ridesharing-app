//
//  ProfileViewModel.h
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "Place.h"

@interface ProfileViewModel : NSObject

@property UIImage *profilePictureImage;

@property NSString *carText;


/* METHODS FOR BASIC INFO */

- (NSString *)getFirstName;

- (void) setFirstName:(NSString *)firstName;

- (NSString *)getLastName;

- (void) setLastName:(NSString *)lastName;

- (NSString *)getEmail;

- (NSString *)getPassword;

- (NSDate *)getDob;

- (void) setDob:(NSDate *)dob;

- (NSString *)getDobString;

- (NSString *)getAge;

- (NSString *)getGender;





- (instancetype) initWithProfile:(UserModel *)user;

- (NSUInteger) getFavPlacesCount;

- (Place *) getPlaceAtIndex:(NSUInteger)indexPath;

- (void) addPlace:(Place *)place;

- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath;

- (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place;

- (void) removePlaceAtIndex:(NSUInteger)indexPath;


- (NSUInteger) getInterestsCount;

- (NSMutableArray *) getInterestsArray;

- (bool) hasInterest:(NSString *)interest;

- (void) updateInterests:(NSArray *)newInterestsArray;
    

- (UIImage *) getProfilePicture;

- (void) setProfilePicture:(UIImage *)image;

+ (NSString *) getZipCodeFromPlacemark:(CLPlacemark *)placemark;


@end
