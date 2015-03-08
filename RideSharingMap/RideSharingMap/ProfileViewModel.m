//
//  ProfileViewModel.m
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ProfileViewModel.h"


@implementation ProfileViewModel {

    //NSMutableArray *placesArray;

}

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

- (void) removePlaceAtIndex:(NSUInteger)indexPath {
    [self.user removePlaceAtIndex:indexPath];
}


@end
