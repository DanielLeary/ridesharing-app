//
//  UserViewModel.m
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "UserViewModel.h"


@implementation UserViewModel {
    
    UserModel *user;
    
}

- (instancetype) initWithModel:(UserModel *)currentUser {
    self = [super init];
    if (self) {
        user = currentUser;
    }
    return self;
}

- (void)updateParseUser {
    [user updateUser];
}


/* METHODS FOR USER INFO */

- (NSString *)getFirstName {
    return [user firstName];
}

- (void) setFirstName:(NSString *)firstName {
    [user setFirstName:firstName];
}

- (NSString *)getLastName {
    return [user lastName];
}

- (void) setLastName:(NSString *)lastName {
    [user setLastName:lastName];
}

- (NSString *)getEmail {
    return [user email];
}

- (NSString *)getPassword {
    return [user password];
}

- (NSDate *)getDob {
    return [user dob];
}

- (void) setDob:(NSDate *)dob {
    [user setDob:dob];
}

- (NSString *)getDobString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy"];
    NSString *dobString = [df stringFromDate:[user dob]];
    return dobString;
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

- (void)setGender:(NSString *)gender {
    [user setGender:gender];
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


/* METHODS FOR INTERESTS */

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


/* METHODS FOR PROFILE PICTURE */

- (UIImage *) getProfilePicture {
    return [user profilePicture];
}

- (void) setProfilePicture:(UIImage *)image {
    [user setProfilePicture:image];
}


/* METHODS FOR LOGIN & SIGNUP */

- (BOOL)loginwithEmail:(NSString*)email andPassword:(NSString *)password {
    return ([PFUser logInWithUsername:email password:password] != NULL);
}

- (int)checkSignupErrorsForFirstName:(NSString *)firstName andLastName:(NSString *)lastName andPassword:(NSString *)password {
    if (firstName.length <2 ) {
        return FIRSTNAME_ERROR;
    }
    if (lastName.length<2) {
        return LASTNAME_ERROR;
    }
    //check password
    BOOL containsLetter = NSNotFound != [password rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location;
    BOOL containsNumber = NSNotFound != [password rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet].location;
    if (!containsLetter || !containsNumber || password.length < 6) {
        return PASSWORD_ERROR;
    }
    return NO_ERROR;
}

- (int)signupWithEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName andLastName:(NSString *)lastName {
    //TODO deal with different types of errors while signing up
    if (firstName.length <2 ) {
        return FIRSTNAME_ERROR;
    }
    if (lastName.length<2) {
        return LASTNAME_ERROR;
    }
    
    BOOL containsLetter = NSNotFound != [password rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location;
    BOOL containsNumber = NSNotFound != [password rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet].location;
    if (!containsLetter || !containsNumber || password.length < 6) {
        return PASSWORD_ERROR;
    }
    
    PFUser *pfUser = [PFUser user];
    pfUser.username = email;
    pfUser.password = password;
    
    pfUser[@"Surname"] = lastName;
    pfUser[@"Name"] = firstName;
    
    if (![pfUser signUp]){
        return EMAIL_ERROR;
    };
    return NO_ERROR;
}


/* METHODS FOR GEOCODING */

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
