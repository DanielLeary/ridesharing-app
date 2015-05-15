//
//  SelectConfirmationViewController.h
//  RideSharingMap
//
//  Created by Shah, Priyav on 14/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Ride.h"

@interface SelectConfirmationViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *driverName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *pickupLocation;
@property (weak, nonatomic) IBOutlet UILabel *destinationLocation;
@property (weak, nonatomic) IBOutlet MKMapView *map;
- (IBAction)submitRequest:(UIButton *)sender;
@property Ride* ride;


@end
