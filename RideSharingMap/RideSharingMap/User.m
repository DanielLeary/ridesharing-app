//
//  User.m
//  RideSharingMap
//
//  Created by Lin Han on 13/5/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

// [PFUser currentUser] is a local cache of the current logged in user
// an instance of [PFUser currentUser] is a copy of the cache and
// and needs to be refreshed from time to time

// subclassing PFUser can add more functionality to users that does not need to be stored in Parse
// however, subclasses of PFUser are NOT cached, so we will make variables in the subclass static
// assume User will only be used to reference the current user


#import "User.h"
#import <Parse/PFObject+Subclass.h>

@interface User ()

//@property NSMutableArray *favPlacesArray; //stores names only?
//@property NSMutableArray *interestsArray;

@end


@implementation User {
    
    //PFUser *user;
    
}

//@dynamic favPlacesArray;
//@dynamic interestsArray;

static NSMutableArray *favPlacesArray;
//static NSMutableArray *interestsArray;


+ (User *)user {
    return (User *)[PFUser user];
}

+ (User *)currentUser {
    User *user = (User *)[PFUser currentUser];
    //[User pullFavPlacesFromParse];
    return user;
}

+ (void) pullFromParse {
    [self pullFavPlacesFromParse];
}


/* METHODS FOR USER INFO */

- (NSString *)getFirstName {
    return self[Pfirstname];
}

- (void) setFirstName:(NSString *)firstName {
    self[Pfirstname] = firstName;
}

- (NSString *)getLastName {
    return self[Plastname];
}

- (void) setLastName:(NSString *)lastName {
    self[Plastname] = lastName;
}

- (NSString *)getUsername {
    return self[Pusername];
}

- (NSString *)getPassword {
    return self[Ppassword];
}

- (NSDate *)getDob {
    return self[Pdob];
}

- (void) setDob:(NSDate *)newDob {
    self[Pdob] = newDob;
}

- (NSString *)getDobString {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *dobString = [dateformatter stringFromDate:self[Pdob]];
    return dobString;
}

- (NSString *) getAge {
    NSDate *dateOfBirth = self[Pdob];
    NSDate *now = [NSDate date];
    NSDateComponents *ageComps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:0];
    NSString *age = [NSString stringWithFormat:@"%ld", (long)ageComps.year];
    return age;
}

- (NSString *) getGender {
    return self[Pgender];
}

- (void)setGender:(NSString *)newGender {
    self[Pgender] = newGender;
}

- (NSString *) getPointsString {
    return [self[Ppoints] stringValue];
}

- (void) addPoints:(NSUInteger)morePoints {
    NSNumber *points = self[Ppoints];
    NSUInteger p = points.intValue;
    p += morePoints;
    self[Ppoints] = [NSNumber numberWithInteger:p];
}


/* METHODS FOR FAV PLACES */

+ (NSUInteger) getFavPlacesCount {
    //return [self[favplaces] count];
    return [favPlacesArray count];
}

+ (Place *) getPlaceAtIndex:(NSUInteger)indexPath {
    /*
    PFUser *user = [PFUser currentUser];
    NSArray *favPlaces = user[favplaces];
    NSString *placeId = [favPlaces objectAtIndex:indexPath];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FavLocations"];
    PFObject *object = [query getObjectWithId:placeId];
    
    NSString *name = object[@"name"];
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = (CLLocationDegrees)[object[@"long"] doubleValue];
    coordinate.latitude = (CLLocationDegrees)[object[@"lat"] doubleValue];
    
    Place *place = [[Place alloc] initWithName:name andCoordinates:coordinate];
    return place;
     */
    return [favPlacesArray objectAtIndex:indexPath];
}

+ (void) addPlace:(Place *)place {
    PFUser *user = [PFUser currentUser];
    
    [favPlacesArray addObject:place];
    
    // create new object to put into parse
    PFObject* favPlace = [PFObject objectWithClassName:@"FavLocations"];
    favPlace[@"name"] = place.name;
    favPlace[@"long"] = [NSNumber numberWithDouble:(double)place.coordinates.longitude];
    favPlace[@"lat"] = [NSNumber numberWithDouble:(double)place.coordinates.latitude];
    [favPlace save];
    
    NSString *placeId = [favPlace objectId];
    NSMutableArray *favPlacesId = user[Pfavplaces];
    [favPlacesId addObject:placeId];
    user[Pfavplaces] = favPlacesId;
    
    [user save];
}

+ (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place {
    /*
    PFUser *user = [PFUser currentUser];
    [self removePlaceAtIndex:indexPath];
    [self addPlace:place];
     */
    [favPlacesArray replaceObjectAtIndex:indexPath withObject:place];
}

+ (void) removePlaceAtIndex:(NSUInteger)indexPath {
    PFUser *user = [PFUser currentUser];
    
    [favPlacesArray removeObjectAtIndex:indexPath];
    
    NSMutableArray *favPlacesId = user[Pfavplaces];
    NSString *placeId = favPlacesId[indexPath];
    [favPlacesId removeObjectAtIndex:indexPath];
    user[Pfavplaces] = favPlacesId;
    
    // !!!!!!!!!!!!!!!!
    // remove from favLocations table
    PFObject *placeObject = [PFObject objectWithoutDataWithClassName:@"FavLocations" objectId:placeId];
    [placeObject deleteInBackground];
    
    /*
     PFQuery *query = [PFQuery queryWithClassName:@"FavLocations"];
     [query whereKey:@"objectId" equalTo:placeId];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     for (int i=0; i<objects.count; i++) {
     PFObject *object = [objects objectAtIndexi];
     [object removeObjectForKey:<#(NSString *)#>]
     }
     }*/
    
    [user save];
}

+ (void) pullFavPlacesFromParse {
    PFUser *user = [PFUser currentUser];
    //[self.favPlacesArray removeAllObjects];
    favPlacesArray = [[NSMutableArray alloc] init];
    NSMutableArray *favPlacesId = [[NSMutableArray alloc] initWithArray:user[Pfavplaces]];
    
    for (NSString *placeId in favPlacesId) {
        PFQuery *query = [PFQuery queryWithClassName:@"FavLocations"];
        PFObject *object = [query getObjectWithId:placeId];
        
        NSString *name = object[@"name"];
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = (CLLocationDegrees)[object[@"long"] doubleValue];
        coordinate.latitude = (CLLocationDegrees)[object[@"lat"] doubleValue];
        
        Place *place = [[Place alloc] initWithName:name andCoordinates:coordinate];
        [favPlacesArray addObject:place];
    }
}


/* METHODS FOR INTERESTS */

- (NSUInteger) getInterestsCount {
    return [self[Pinterests] count];
}

- (NSMutableArray *) getInterestsArray {
    return self[Pinterests];
}

- (bool) hasInterest:(NSString *)interest {
    //interestsArray = user[interestArray];
    return [self[Pinterests] containsObject:interest];
}

- (void) updateInterests:(NSArray *)newInterestArray {
    //[interestsArray removeAllObjects];
    //[interestsArray addObjectsFromArray:newInterestArray];
    self[Pinterests] = (NSMutableArray *)newInterestArray;
}


/* METHODS FOR PROFILE PICTURE */

- (NSData *) getProfilePicture {
    PFFile* file = self[Ppicture];
    NSData *imageData = [file getData];
    return imageData;
}

- (void) setProfilePicture:(UIImage *)profilePicture {
    NSData *imageData = UIImagePNGRepresentation(profilePicture);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    self[Ppicture] = imageFile;
    [self save];
}


@end
