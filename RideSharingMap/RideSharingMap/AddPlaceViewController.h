//
//  AddPlaceViewController.h
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "User.h"

@class AddPlaceViewController;

@interface AddPlaceViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>

// if editing an existing place

@property (nonatomic) BOOL editing;

@property (nonatomic) NSUInteger placeIndexPath;

// UI

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITextField *placeNameField;

@property (weak, nonatomic) IBOutlet UITextField *placeLocationField;

@end
