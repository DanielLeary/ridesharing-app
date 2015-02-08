//
//  ViewController.h
//  RideSharingMap
//
//  Created by Vaneet Mehta on 07/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)goToCurrentLocation:(UIBarButtonItem *)sender;

@end

