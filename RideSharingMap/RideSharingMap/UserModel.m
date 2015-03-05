//
//  UserModel.m
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
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
        PFUser * currentUser = [PFUser currentUser];
        if (currentUser) {
            _firstName = currentUser[firstnameString];
            _username = currentUser[surnameString];
            _car = currentUser[carString];
            _position = currentUser[positionString];
            _username = currentUser[usernameString];
            
        }
    }
    return self;
}
-(BOOL)updateUser {
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
