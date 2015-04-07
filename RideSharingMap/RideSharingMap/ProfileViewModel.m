//
//  ProfileViewModel.m
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ProfileViewModel.h"


@implementation ProfileViewModel {
    
    UserModel *user;
    
}

- (instancetype) initWithProfile:(UserModel *)currentUser {
    self = [super init];
    if (self) {
        user = currentUser;
        self.firstNameText = user.firstName;
        self.lastNameText = user.lastName;
        self.carText = user.car;
        self.profilePictureImage = user.profilePicture;
    }
    return self;
}


/* METHODS FOR USER INFO */

- (NSString *) getFirstName {
    return [user firstName];
}

- (NSString *) getLastName {
    return [user lastName];
}

- (NSString *) getEmail {
    return [user email];
}

- (NSDate *) getDob {
    return [user dob];
}

- (NSString *) getAge {
    NSDate *dob = [user dob];
    NSDate *now = [NSDate date];
    NSDateComponents *ageComps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dob toDate:now options:0];
    NSString *age = [NSString stringWithFormat:@"%ld", (long)ageComps.year];
    return age;
}

- (NSString *) getGender {
    return [user gender];
}


/* METHODS FOR FAV PLACES */

- (NSUInteger) getFavPlacesCount {
    return [user getFavPlacesCount];
}

- (Place *) getPlaceAtIndex:(NSUInteger)indexPath {
    return [user getPlaceAtIndex:indexPath];
}

- (void) addPlace:(Place *)place {
    [user addPlace:place];
}

- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath {
    [user insertPlace:place atIndex:indexPath];
}

- (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place {
    [user replacePlaceAtIndex:indexPath withPlace:place];
}

- (void) removePlaceAtIndex:(NSUInteger)indexPath {
    [user removePlaceAtIndex:indexPath];
}


/* methods for interests */

- (NSUInteger) getInterestsCount {
    return [user getInterestsCount];
}

- (NSMutableArray *) getInterestsArray {
    return [user getInterestsArray];
}

- (bool) hasInterest:(NSString *)interest {
    return [user hasInterest:interest];
}

- (void) updateInterests:(NSArray *)newInterestsArray {
    [user updateInterests:newInterestsArray];
}

/* methods for profile picture */

- (UIImage *) getProfilePicture {
    return [user profilePicture];
}


/* methods for geocoding */

- (void) setProfilePicture:(UIImage *)image {
    [user setProfilePicture:image];
}


+ (NSString *) getZipCodeFromPlacemark:(CLPlacemark *)placemark {
    NSString *address = [NSString stringWithFormat:@"%@", placemark.postalCode];
    return address;
}

+ (void) getPlacemarkFromCoordinates:(CLLocationCoordinate2D)coordinates {
    CLLocation *location = [[CLLocation alloc] initWithLatitude: coordinates.latitude longitude:coordinates.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    typeof(self) __weak weakSelf = self;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            [weakSelf getZipCodeFromPlacemark:placemark];
        }
    }];
}


@end
