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
#define pictureString @"ProfilePicture"

@implementation UserModel {
    
    PFUser *user;
    NSMutableArray *favPlacesArray;
    NSMutableArray *interestsArray;

}


-(id)init {
    self = [super init];
    if (self) {
        user = [PFUser currentUser];
        if (user) {
            Place *home = [[Place alloc] initWithName:@"Home"];
            Place *work = [[Place alloc] initWithName:@"Work"];
            favPlacesArray = [[NSMutableArray alloc] initWithObjects:home, work, nil];
            
            interestsArray = [[NSMutableArray alloc] init];
            
            self.firstName = user[firstnameString];
            self.lastName = user[surnameString];
            self.car = user[carString];
            self.position = user[positionString];
            //NSString *pathForBlankProfilePicture = [[NSBundle mainBundle] pathForResource:@"checkmark" ofType:@"png"];
            //self.profilePicture = [[UIImage alloc] initWithContentsOfFile:pathForBlankProfilePicture];
        }
    }
    return self;
}

-(BOOL)updateUser {
    if (self.lastName != nil) {
        user[surnameString] = self.lastName;
    }
    if (self.firstName != nil) {
        user[firstnameString] = self.firstName;
    }
    if (self.car != nil) {
        user[carString] = self.car;
    }
    if (self.position != nil) {
        user[positionString] = self.position;
    }
    if (self.gender != nil) {
        user[genderString] = self.gender;
    }
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            NSLog(@"updated user");
        } else {
            NSLog(@"updated user FAIL");
        }
    }];
    return true;
}


/* METHODS FOR FAV PLACES */

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

/*
- (void) setProfilePicture:(UIImage *)image {
    self.profilePicture = image;
    _profilePicture = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"Profileimage.png" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (succeeded) {
                PFUser *user = [PFUser currentUser];
                if (user != nil) {
                    user[pictureString] = imageFile;
                    [user saveInBackground];
                }
            }
        } else {
            // Handle error
        }
    }];
}*/

@end
