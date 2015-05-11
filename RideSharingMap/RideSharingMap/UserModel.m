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
#define interestArray @"Interests"
#define passwordString @"password"

@implementation UserModel {
    
    // PROFILE
    PFUser *user;
    NSMutableArray *favPlacesArray;
    NSMutableArray *interestsArray;
    
    // AS PASSENGER
    NSMutableArray *gettingRideFromArray;
    NSMutableArray *requestsSentArray;
    
    // AS DRIVER
    NSMutableArray *givingRideToArray;
    NSMutableArray *requestsReceivedArray;
    
}


-(id)init {
    self = [super init];
    if (self) {
        user = [PFUser currentUser];
        if (user) {
            self.firstName = user[firstnameString];
            self.lastName = user[surnameString];
            self.username = user[usernameString];
            self.password = user[passwordString];
            
            self.car = user[carString];
            self.position = user[positionString];

            Place *home = [[Place alloc] initWithName:@"Home"];
            Place *work = [[Place alloc] initWithName:@"Work"];
            favPlacesArray = [[NSMutableArray alloc] initWithObjects:home, work, nil];
            
            interestsArray = [[NSMutableArray alloc] init];
            [interestsArray removeAllObjects];
            [interestsArray addObjectsFromArray:user[interestArray]];
        }
    }
    return self;
}

- (void)logOut {
    [PFUser logOut];
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
    return [user[interestArray] count];
}

- (NSMutableArray *) getInterestsArray {
    return user[interestArray];
}

- (bool) hasInterest:(NSString *)interest {
    return [user[interestArray] containsObject:interest];
}

- (void) updateInterests:(NSArray *)newInterestArray {
    user[interestArray] = newInterestArray;
    [user save];
    
}


/* methods for profile picture */

-(NSData*) getPicture{
    PFFile* file = user[pictureString];
    NSData *imageData = [file getData];
    return imageData;
}

-(void) setProfilePicture:(UIImage *)profilePicture{
    NSData *imageData = UIImagePNGRepresentation(profilePicture);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    
    user[pictureString] = imageFile;
    [user save];

}


@end
