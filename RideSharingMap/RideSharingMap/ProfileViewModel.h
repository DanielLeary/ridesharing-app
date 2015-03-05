//
//  ProfileViewModel.h
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "Place.h"

@interface ProfileViewModel : NSObject

@property UserModel *user;

@property NSString *usernameText;

@property NSString *firstNameText;

@property NSString *lastNameText;

@property NSString *carText;


- (instancetype) initWithProfile:(UserModel *)user;

- (int) getFavPlacesCount;

- (Place *) getPlaceAtIndex:(NSUInteger)indexPath;

- (void) addPlace:(Place *)place;

- (void) insertPlace:(Place *)place atIndex:(NSUInteger)indexPath;

- (void) removePlaceAtIndex:(NSUInteger)indexPath;


@end
