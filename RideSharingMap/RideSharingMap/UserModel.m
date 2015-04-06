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
#define genderString @"Gender"


@implementation UserModel {
    
    NSMutableArray *favPlacesArray;
    NSMutableArray *interestsArray;

}

-(id)init {
    self = [super init];
    if (self) {
        _currentUser = [PFUser currentUser];
        if (_currentUser) {
            Place *home = [[Place alloc] initWithName:@"Home"];
            Place *work = [[Place alloc] initWithName:@"Work"];
            favPlacesArray = [[NSMutableArray alloc] initWithObjects:home, work, nil];
            interestsArray = [[NSMutableArray alloc] init];
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
    if(_lastname != nil) {
        _currentUser[surnameString]=_lastname;
    }
    if(_firstname != nil) {
        _currentUser[firstnameString]=_firstname;
    }
    if(_car != nil) {
        _currentUser[carString]=_car;
    }
    if(_position != nil) {
        _currentUser[positionString] = _position;
    }
    if (_username != nil) {
        _currentUser[usernameString] = _username;
    }
    if (_gender != nil) {
        _currentUser[genderString] = _gender;
    }
    
    [_currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            NSLog(@"updated user");
        } else {
            NSLog(@"updated user FAIL");
        }
    }];
    return true;
}


/* methods for fav places */

- (NSUInteger) getFavPlacesCount {
    return [favPlacesArray count];
}

- (Place *) getPlaceAtIndex:(NSUInteger)indexPath {
    return [favPlacesArray objectAtIndex:indexPath];
}

- (void) addPlace:(Place *)place {
    [favPlacesArray addObject:place];
    Place *place2 = [favPlacesArray objectAtIndex:2];
    NSLog(@"array: %@, %f, %f", place2.name, place2.coordinates.latitude, place2.coordinates.longitude);
}

- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath {
    [favPlacesArray insertObject:place atIndex:indexPath];
}

- (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place {
    [favPlacesArray replaceObjectAtIndex:indexPath withObject:place];
}

- (void) removePlaceAtIndex:(NSUInteger)indexPath {
    [favPlacesArray removeObjectAtIndex:indexPath];
}


/* METHODS FOR INTERESTS */

- (NSUInteger) getInterestsCount {
    return [interestsArray count];
}

- (NSMutableArray *) getInterestsArray {
    return interestsArray;
}

- (bool) hasInterest:(NSString *)interest {
    return [interestsArray containsObject:interest];
}

- (void) updateInterests:(NSArray *)newInterestArray {
    [interestsArray removeAllObjects];
    [interestsArray addObjectsFromArray:newInterestArray];
}


/* methods for profile picture */

- (UIImage *) getProfilePicture {
    return self.profilePicture;
}

- (void) setProfilePicture:(UIImage *)image {
    self.profilePicture = image;
}

@end
