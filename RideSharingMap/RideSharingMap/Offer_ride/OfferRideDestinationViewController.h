//
//  OfferRideFinishViewController.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 20/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Ride.h"
#import "User.h"

@interface OfferRideDestinationViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Ride *ride;

//initiates the search
- (IBAction)SearchBox:(UITextField *)sender;

//zooms the map to current location
- (IBAction)locationButton:(UIButton *)sender;

//creates UIActionSheet to display favourite locations
- (IBAction)favouritesActionSheet:(id)sender;
@end
