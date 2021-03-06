//
//  JourneyView.h
//  RideSharingMap
//
//  Created by Daniel Leary on 12/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface JourneyView : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) PFObject *item;
@property (weak, nonatomic) IBOutlet UILabel *give_get;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *pickupAddress;
@property (weak, nonatomic) IBOutlet UILabel *destAddress;
@property (weak, nonatomic) IBOutlet MKMapView *map;
- (IBAction)complete:(id)sender;
- (IBAction)delete:(id)sender;

@end
