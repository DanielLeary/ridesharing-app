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


@implementation UserModel {
    
    NSMutableArray *favPlacesArray;

}

-(id)init {
    self = [super init];
    if (self) {
        _currentUser = [PFUser currentUser];
        if (_currentUser) {
            Place *home = [[Place alloc] initWithName:@"Home"];
            Place *work = [[Place alloc] initWithName:@"Work"];
            self->favPlacesArray = [[NSMutableArray alloc] initWithObjects:home, work, nil];
            _firstname = _currentUser[firstnameString];
            _lastname = _currentUser[surnameString];
            _car = _currentUser[carString];
            _position = _currentUser[positionString];
            _username = _currentUser[usernameString];

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

- (NSUInteger) getFavPlacesCount {
    return [favPlacesArray count];
}

- (Place *) getPlaceAtIndex:(NSUInteger)indexPath {
    return [favPlacesArray objectAtIndex:indexPath];
}

- (void) addPlace:(Place *)place {
    [favPlacesArray insertObject:place atIndex:favPlacesArray.count];
}

- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath {
    [favPlacesArray insertObject:place atIndex:indexPath];
}

- (void) removePlaceAtIndex:(NSUInteger)indexPath {
    [favPlacesArray removeObjectAtIndex:indexPath];
}

@end
