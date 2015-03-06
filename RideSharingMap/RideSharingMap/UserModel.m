//
//  UserObject.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 04/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//


#import "UserModel.h"
#define firstnameString @"Name"
#define surnameString @"Surname"
#define carString @"Car"
#define positionString @"Position"
#define usernameString @"username"


@implementation UserModel

-(id)init {
    self = [super init];
    if(self) {
        _currentUser = [PFUser currentUser];
        if (_currentUser) {
            _firstname = _currentUser[firstnameString];
            _surname = _currentUser[surnameString];
            _car = _currentUser[carString];
            _position = _currentUser[positionString];
            _userName = _currentUser[usernameString];

        }
    }
    return self;
}
-(BOOL)updateUser {
    /*_currentUser[@"Surname"]=_surname;
    _currentUser[@"Name"]=_firstname;
    _currentUser[@"Car"]=_car;*/
    
    [_currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            NSLog(@"updated user");
        } else {
            NSLog(@"updated user FAIL");
        }
    }];
    return true;
}

@end
