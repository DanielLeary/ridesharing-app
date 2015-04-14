//
//  OfferRideStartViewController.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Ride.h"

@interface OfferRideStartViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Ride *ride;
- (IBAction)SearchBox:(UITextField *)sender;

- (IBAction)finishButton;

@end
