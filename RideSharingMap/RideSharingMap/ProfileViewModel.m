//
//  ProfileViewModel.m
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ProfileViewModel.h"


@implementation ProfileViewModel

- (instancetype) initWithProfile:(UserModel *)user {
    self = [super init];
    if (self) {
        self.user = user;
        self.usernameText = user.username;
        self.firstNameText = user.firstname;
        self.lastNameText = user.lastname;
        self.carText = user.car;
    }
    return self;
}

- (NSUInteger) getFavPlacesCount {
    return [self.user getFavPlacesCount];
}

- (Place *) getPlaceAtIndex:(NSUInteger)indexPath {
    return [self.user getPlaceAtIndex:indexPath];
}

- (void) addPlace:(Place *)place {
    [self.user addPlace:place];
}

- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath {
    [self.user insertPlace:place atIndex:indexPath];
}

- (void) replacePlaceAtIndex:(NSUInteger)indexPath withPlace:(Place *)place {
    [self.user replacePlaceAtIndex:indexPath withPlace:place];
}

- (void) removePlaceAtIndex:(NSUInteger)indexPath {
    [self.user removePlaceAtIndex:indexPath];
}

- (UIImage *) getProfilePicture {
    return [self.user getProfilePicture];
}

- (void) setProfilePicture:(UIImage *)image {
    [self.user setProfilePicture:image];
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
