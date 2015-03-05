//
//  UserModel.h
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserModel : NSObject

// Get and set methods automatically produced by compilor when using property

// Readonly used to state that methods cannot be changed use set method
// The compilor doesn't produce a set method for such properties
@property NSString *firstName;

@property NSString *lastName;

@property NSString *car;

@property NSString *position;

@property NSString *phoneNumber;

@property NSString *username;

@property PFUser *currentUser;


// TODO Constructor that when insantiated checks if there is a user currently
// Logged on and if there is each of these properties are updated
// If not returns False, if there is returns true.
-(id)init;

-(BOOL)updateUser;

// can specify accessor method using getter
@property (readonly, getter=isLoggedIn) BOOL loggedIn;

// get and set methods can be called using dot notation (objectName.fieldname = ValueToSet)
// But these are simply wrappers for [objectName fieldname] and
// [objectName setFieldName:ValueToSet]


// Too specify multiple arguments, we must use secondValue, thirdValue etc e.g below
//+(BOOL) setUserNameAndPassword:(NSString*)userName secondValue:(NSString*)password;
@end


