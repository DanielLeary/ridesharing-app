//
//  AddPlaceViewController.h
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@class AddPlaceViewController;

@protocol AddPlaceViewControllerDelegate <NSObject>

- (void) addNewPlace:(AddPlaceViewController *)vc place:(Place *)place;

- (void) editPlace:(AddPlaceViewController *)vc atIndex:(NSUInteger)indexPath withPlace:(Place *)place;

@end




@interface AddPlaceViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>

// if editing an existing place

@property (nonatomic) BOOL editing;

@property (nonatomic) NSUInteger placeIndexPath;

// UI

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITextField *placeNameField;

@property (weak, nonatomic) IBOutlet UITextField *placeLocationField;

@property (assign, nonatomic) id <AddPlaceViewControllerDelegate> delegate;

@end
