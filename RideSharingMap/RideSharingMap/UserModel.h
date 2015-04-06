//
//  UserModel.h
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> //only for UIImage...
#import <Parse/Parse.h>
#import "Place.h"

@interface UserModel : NSObject

// Get and set methods automatically produced by compilor when using property

// Readonly used to state that methods cannot be changed use set method
// The compilor doesn't produce a set method for such properties

@property (nonatomic) UIImage *profilePicture;

@property (nonatomic) NSString *firstname;

@property (nonatomic) NSString *lastname;

@property (nonatomic) NSString *car;

@property (nonatomic) NSString *position;

@property (nonatomic) NSString *phoneNumber;

@property (nonatomic) NSString *username;

@property (nonatomic) NSString *gender;

@property PFUser *currentUser;


// can specify accessor method using getter
@property (readonly, getter=isLoggedIn) BOOL loggedIn;

// get and set methods can be called using dot notation (objectName.fieldname = ValueToSet)
// But these are simply wrappers for [objectName fieldname] and
// [objectName setFieldName:ValueToSet]


// Too specify multiple arguments, we must use secondValue, thirdValue etc e.g below
//+(BOOL) setUserNameAndPassword:(NSString*)userName secondValue:(NSString*)password;


// TODO Constructor that when insantiated checks if there is a user currently
// Logged on and if there is each of these properties are updated
-(id)init;

-(BOOL)updateUser;


/* methods for fav places */

- (NSUInteger) getFavPlacesCount;

- (Place *) getPlaceAtIndex:(NSUInteger)indexPath;

- (void) addPlace:(Place *)place;

- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath;

- (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place;

- (void) removePlaceAtIndex:(NSUInteger)indexPath;


/* methods for interests */

- (NSUInteger) getInterestsCount;

- (NSMutableArray *) getInterestsArray;

- (bool) hasInterest:(NSString *)interest;

- (void) updateInterests:(NSArray *)newInterestArray;


/* methods for profile picture */

- (UIImage *) getProfilePicture;

- (void) setProfilePicture:(UIImage *)image;


@end


