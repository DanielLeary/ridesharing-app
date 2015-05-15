//
//  OfferRideStartViewController.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//
#import "OfferRideDestinationViewController.h"

@interface OfferRideStartViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Ride *ride;

//initiates the search
- (IBAction)SearchBox:(UITextField *)sender;

//zooms the map to current location
- (IBAction)locationButton:(UIButton *)sender;

//creates UIActionSheet to display favourite locations
- (IBAction)favouritesActionSheet:(id)sender;

@end
