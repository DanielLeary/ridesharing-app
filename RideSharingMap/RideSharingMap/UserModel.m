//
//  UserObject.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 04/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//


#import "UserModel.h"
#import "Place.h"
#import "userDefines.h"


@implementation UserModel {
    
    // PROFILE
    PFUser *user;
    NSMutableArray *favPlacesArray;
    NSMutableArray *interestsArray;
    NSMutableArray *fav_placesID;
    
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
        
        fav_placesID = [[NSMutableArray alloc] initWithCapacity:5];
        favPlacesArray = [[NSMutableArray alloc] initWithCapacity:5];
        interestsArray = [[NSMutableArray alloc] init];
        
        user = [PFUser currentUser];
        if (user) {
            
            [self pullPlacesArray];
            interestsArray = [[NSMutableArray alloc] init];
            
            self.firstName = user[firstnameString];
            self.lastName = user[surnameString];
            self.username = user[usernameString];
            self.password = user[passwordString];
            
            self.car = user[carString];
            self.position = user[positionString];
            
            [interestsArray removeAllObjects];
            [interestsArray addObjectsFromArray:user[interestArray]];
            
            //TODO setting profile pic
            //NSString *pathForBlankProfilePicture = [[NSBundle mainBundle] pathForResource:@"checkmark" ofType:@"png"];
            //self.profilePicture = [[UIImage alloc] initWithContentsOfFile:pathForBlankProfilePicture];
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
            NSLog(@"updated user"); //TODO remove
        } else {
            NSLog(@"updated user FAIL"); //TODO remove
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
    
    double lat = (double)place.coordinates.latitude;
    double lon = (double)place.coordinates.longitude;
    
    PFObject* fav_place = [PFObject objectWithClassName:@"FavLocations"];
    fav_place[@"name"] = place.name;
    fav_place[@"long"] = [NSNumber numberWithDouble:lon];
    fav_place[@"lat"] = [NSNumber numberWithDouble:lat];
    bool test = [fav_place save]; //TODO remove
    NSString* fav_id = [fav_place objectId];
    [fav_placesID addObject:fav_id];
    user[favPlaces] = fav_placesID;
    [user save];
}


-(NSMutableArray*) getFavPlaces{
    return user[favPlaces];
}


- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath {
    [favPlacesArray insertObject:place atIndex:indexPath];
}


- (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place {
    [favPlacesArray replaceObjectAtIndex:indexPath withObject:place];

}


- (void) removePlaceAtIndex:(NSUInteger)indexPath {
    [favPlacesArray removeObjectAtIndex:indexPath];
    [fav_placesID removeObjectAtIndex:indexPath];
    user[favPlaces] = fav_placesID;
    //[user save]; //TODO sort this out
}


-(void) pullPlacesArray{
    
    [favPlacesArray removeAllObjects];
    NSMutableArray* fav_ids = [[NSMutableArray alloc] initWithArray:user[favPlaces]];
    
    for (NSString* string in fav_ids){
        PFQuery *query = [PFQuery queryWithClassName:@"FavLocations"];
        PFObject* place = [query getObjectWithId:string];
        
        CLLocationCoordinate2D coord;
        coord.longitude = (CLLocationDegrees)[place[@"long"] doubleValue];
        coord.latitude = (CLLocationDegrees)[place[@"lat"] doubleValue];
        
        Place *fav = [[Place alloc] initWithName:place[@"name"] andCoordinates:coord];
        
        [favPlacesArray addObject:fav];
    }
    
    [fav_placesID removeAllObjects];
    [fav_placesID addObjectsFromArray:user[favPlaces]];
}

/* METHODS FOR INTERESTS */


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
