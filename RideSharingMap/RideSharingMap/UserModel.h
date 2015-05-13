//
//  UserModel.h
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 
#import <Parse/Parse.h>
#import "Place.h"


@interface UserModel : NSObject

/*

@property (strong, nonatomic) NSString *firstName;

@property (strong, nonatomic) NSString *lastName;

@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *gender;

@property (strong, nonatomic) NSString *car;

@property (strong, nonatomic) NSString *position;

@property (strong, nonatomic) NSString *phoneNumber;

@property (strong, nonatomic) NSDate *dob;

@property (strong, nonatomic) UIImage *profilePicture;


// specified getter accessor for loggedIn
@property (readonly, getter=isLoggedIn) BOOL loggedIn;


- (id)init;

// called when logout button is pressed
- (void)logOut;

//updates basic user info: name, surname, car etc.
- (BOOL)updateUser;


/* METHODS FOR FAV PLACES */

//returns the number of saved favourite places
/*
- (NSUInteger) getFavPlacesCount;

//returns a favourite place at indexPath from the fav locations array
- (Place *) getPlaceAtIndex:(NSUInteger)indexPath;

//adds place to the end of the fav places array
- (void) addPlace:(Place *)place;

//return the array with all fav locations
- (NSMutableArray*) getFavPlaces;

// inserts place at indexPath into the fav locations array
- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath;

//replaces location at indexPath with place
- (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place;

//removes location at indexPath from the fac locations array
- (void) removePlaceAtIndex:(NSUInteger)indexPath;

//pulls fav locations from Parse
- (void) pullPlacesArray;
*/

/* METHODS FOR INTERESTS */

//returns saved interests
/*
- (NSMutableArray *) getInterestsArray;

//returns true if interest exists in the interests array
- (bool) hasInterest:(NSString *)interest;

//updates user's interests and saves them to Parse
- (void) updateInterests:(NSArray *)newInterestArray;
*/
 
/* METHODS FOR PROFILE PICTURE */


//returns the data of the profile picture
/*
-(NSData*) getPicture;

//sets the profile picture and saves the data (file) to Parse
-(void) setProfilePicture:(UIImage *)profilePicture;
*/

@end


