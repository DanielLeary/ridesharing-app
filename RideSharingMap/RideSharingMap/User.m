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

static const NSUInteger initialArrayCap = 5;


@implementation User

static NSMutableArray *favPlacesArray;


+ (User *)user {
    return (User *)[PFUser user];
}

+ (User *)currentUser {
    User *user = (User *)[PFUser currentUser];
    return user;
    
}

//static class constructor for static variables
+ (void) initialize {
    favPlacesArray = [[NSMutableArray alloc] initWithCapacity:initialArrayCap];
}

+ (void) pullFromParse {
    [self pullFavPlacesFromParse];
}

+ (void) logOutUser {
    [[self currentUser] save];
    [favPlacesArray removeAllObjects];
    [User logOut];
}


/* METHODS FOR USER INFO */

- (NSString *)getFirstName {
    return self[P_FIRSTNAME];
}

- (void) setFirstName:(NSString *)firstName {
    self[P_FIRSTNAME] = firstName;
}

- (NSString *)getLastName {
    return self[P_LASTNAME];
}

- (void) setLastName:(NSString *)lastName {
    self[P_LASTNAME] = lastName;
}

- (NSString *)getUsername {
    return self[P_USERNAME];
}

- (NSString *)getPassword {
    return self[P_PASSWROD];
}

- (NSDate *)getDob {
    return self[P_DOB];
}

- (void) setDob:(NSDate *)newDob {
    self[P_DOB] = newDob;
}

- (NSString *)getDobString {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *dobString = [dateformatter stringFromDate:self[P_DOB]];
    return dobString;
}

- (NSString *) getAge {
    NSDate *dateOfBirth = self[P_DOB];
    NSDate *now = [NSDate date];
    NSDateComponents *ageComps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:0];
    NSString *age = [NSString stringWithFormat:@"%ld", (long)ageComps.year];
    return age;
}

- (NSString *) getGender {
    return self[P_GENDER];
}

- (void)setGender:(NSString *)newGender {
    self[P_GENDER] = newGender;
}

- (NSString *) getPointsString {
    return [self[P_POINTS] stringValue];
}

- (void) addPoints:(NSUInteger)morePoints {
    NSNumber *points = self[P_POINTS];
    NSUInteger p = points.intValue;
    p += morePoints;
    self[P_POINTS] = [NSNumber numberWithInteger:p];
}


/* METHODS FOR FAV PLACES */

+ (NSUInteger) getFavPlacesCount {
    return [favPlacesArray count];
}

+ (Place *) getPlaceAtIndex:(NSUInteger)indexPath {
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
    NSMutableArray *favPlacesId = [[NSMutableArray alloc] initWithArray:user[P_FAVPLACES]];
    [favPlacesId addObject:placeId];
    user[P_FAVPLACES] = favPlacesId;
    
    [user save];
}

+ (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place {
    [favPlacesArray replaceObjectAtIndex:indexPath withObject:place];
    
    PFUser *user = [PFUser currentUser];
    NSMutableArray *favPlacesId = [[NSMutableArray alloc] initWithArray:user[P_FAVPLACES]];
    NSString *placeId = favPlacesId[indexPath];
    
    // update in favLocations table
    PFQuery *query = [PFQuery queryWithClassName:@"FavLocations"];
    [query getObjectInBackgroundWithId:placeId block:^(PFObject *placeObject, NSError *error) {
        placeObject[@"name"] = place.name;
        placeObject[@"lat"] = [NSNumber numberWithDouble:(double)place.coordinates.latitude];
        placeObject[@"long"] = [NSNumber numberWithDouble:(double)place.coordinates.longitude];
        [placeObject saveInBackground];
    }];
}

+ (void) removePlaceAtIndex:(NSUInteger)indexPath {
    PFUser *user = [PFUser currentUser];
    
    [favPlacesArray removeObjectAtIndex:indexPath];
    
    NSMutableArray *favPlacesId = [[NSMutableArray alloc] initWithArray:user[P_FAVPLACES]];
    NSString *placeId = favPlacesId[indexPath];
    [favPlacesId removeObjectAtIndex:indexPath];
    user[P_FAVPLACES] = favPlacesId;
    
    // remove from favLocations table
    PFObject *placeObject = [PFObject objectWithoutDataWithClassName:@"FavLocations" objectId:placeId];
    [placeObject deleteInBackground];
    
    [user save];
}

+ (void) pullFavPlacesFromParse {
    PFUser *user = [PFUser currentUser];
    //favPlacesArray = [[NSMutableArray alloc] init];
    [favPlacesArray removeAllObjects];
    NSMutableArray *favPlacesId = [[NSMutableArray alloc] initWithArray:user[P_FAVPLACES]];
    
    for (NSString *placeId in favPlacesId) {
        PFQuery *query   = [PFQuery queryWithClassName:@"FavLocations"];
        PFObject *object = [query getObjectWithId:placeId];
        
        NSString *name = object[@"name"];
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = (CLLocationDegrees)[object[@"long"] doubleValue];
        coordinate.latitude  = (CLLocationDegrees)[object[@"lat"]  doubleValue];
        
        Place *place = [[Place alloc] initWithName:name andCoordinates:coordinate];
        [favPlacesArray addObject:place];
    }
}


/* METHODS FOR INTERESTS */

- (NSUInteger) getInterestsCount {
    return [self[P_INTERESTS] count];
}

- (NSMutableArray *) getInterestsArray {
    return self[P_INTERESTS];
}

- (bool) hasInterest:(NSString *)interest {
    return [self[P_INTERESTS] containsObject:interest];
}

- (void) updateInterests:(NSArray *)newInterestArray {
    self[P_INTERESTS] = (NSMutableArray *)newInterestArray;
}


/* METHODS FOR PROFILE PICTURE */

- (NSData *) getProfilePicture {
    PFFile* file = self[P_PICTURE];
    NSData *imageData = [file getData];
    return imageData;
}

- (void) setProfilePicture:(UIImage *)profilePicture {
    NSData *imageData = UIImagePNGRepresentation(profilePicture);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    self[P_PICTURE]    = imageFile;
    [self save];
}


@end
