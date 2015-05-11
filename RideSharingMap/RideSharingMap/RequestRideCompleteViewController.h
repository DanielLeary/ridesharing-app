//
//  RequestRideCompleteViewController.h
//  RideSharingMap
//
//  Created by Vaneet Mehta on 11/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Requests.h"

@interface RequestRideCompleteViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) Requests *request;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)finishButton;



@end
