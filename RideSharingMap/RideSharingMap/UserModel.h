//
//  UserObject.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 04/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserModel : PFUser

// Get and set methods automatically produced by compilor when using property

// Readonly used to state that methods cannot be changed use set method
// The compilor doesn't produce a set method for such properties
/*@property NSString *firstname;

@property NSString *surname;

@property NSString *car;

@property NSString *position;

@property NSString *phoneNumber;

@property NSString *userName;

@property PFUser *currentUser;
*/

// TODO Constructor that when insantiated checks if there is a user currently
// Logged on and if there is each of these properties are updated
// If not returns False, if there is returns true.
-(id)init;
-(NSString *)getFirstName;
-(void)setFirstName:(NSString*) firstname;
-(NSString *)getSurname;
-(void)setSurname:(NSString*) surname;
-(NSString *)getCar;
-(void)setCar:(NSString*) car;
-(NSString *)getPosition;
-(void)setPosition:(NSString*) position;
-(NSString *)getPhonenumber;
-(void)setUsername:(NSString *)username;
-(NSString *)getUserName;
//-(NSString *)getSavedLocation;


-(BOOL)updateUser;

// can specify accessor method using getter
@property (readonly, getter=isLoggedIn) BOOL loggedIn;

// get and set methods can be called using dot notation (objectName.fieldname = ValueToSet)
// But these are simply wrappers for [objectName fieldname] and
// [objectName setFieldName:ValueToSet]


// Too specify multiple arguments, we must use secondValue, thirdValue etc e.g below
//+(BOOL) setUserNameAndPassword:(NSString*)userName secondValue:(NSString*)password;
@end
