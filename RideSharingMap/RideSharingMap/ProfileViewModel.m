//
//  ProfileViewModel.m
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ProfileViewModel.h"



@implementation ProfileViewModel {

    NSMutableArray *placesArray;

}

- (instancetype) initWithProfile:(UserModel *)user {
    self = [super init];
    if (self) {
        self.user = user;
        self.usernameText = user.username;
        self.firstNameText = user.firstname;
        self.lastNameText = user.lastname;
        self.carText = user.car;
        placesArray = [[NSMutableArray alloc] initWithObjects:@"Home", @"Work", nil];
    }
    return self;
}

- (int) getFavPlacesCount {
    return [placesArray count];
}

- (Place *) getPlaceAtIndex:(NSUInteger)indexPath {
    return [placesArray objectAtIndex:indexPath];
}

- (void) addPlace:(Place *)place {
    [placesArray insertObject:place atIndex:placesArray.count];
}

- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath {
    [placesArray insertObject:place atIndex:indexPath];
}

- (void) removePlaceAtIndex:(NSUInteger)indexPath {
    [placesArray removeObjectAtIndex:indexPath];
}


@end
