//
//  Place.m
//  RideSharingMap
//
//  Created by Han, Lin on 05/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Place.h"

@implementation Place

- (id) initWithName:(NSString *)name andCoordinates:(CLLocationCoordinate2D *)coordinates {
    self = [super init];
    if (self) {
        self.name = name;
        self.coordinates = coordinates;
    }
    return self;
}

- (NSString *) getName {
    return self.name;
}

- (CLLocationCoordinate2D *) getCoordinates {
    return self.coordinates;
}

- (float) getLatitude {
    return self.coordinates->latitude;
}

- (float) getLongitude {
    return self.coordinates->latitude;
}

@end
