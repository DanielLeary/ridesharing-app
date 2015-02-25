//
//  AddPlaceViewController.h
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@class AddPlaceViewController;

@protocol AddPlaceViewControllerDelegate <NSObject>

- (void)addNewPlace:(AddPlaceViewController *)vc withName:(NSString *)placeName andCoord:(CLLocationCoordinate2D)placeCoord;
- (void)editPlace:(AddPlaceViewController *)vc withName:(NSString *)placeName andCoord:(CLLocationCoordinate2D)placeCoord;

@end




@interface AddPlaceViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>

@property (nonatomic) BOOL editing;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITextField *placeNameField;

@property (weak, nonatomic) IBOutlet UITextField *placeLocationField;

@property (assign, nonatomic) id <AddPlaceViewControllerDelegate> delegate;

@end
