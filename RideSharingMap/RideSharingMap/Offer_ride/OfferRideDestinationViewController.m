//
//  OfferRideFinishViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 20/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "OfferRideDestinationViewController.h"
#import "OfferRideStartViewController.h"


@interface OfferRideDestinationViewController ()

@property (strong, atomic) CLLocationManager* locationManager;
@property (strong, atomic) MKPointAnnotation* pin;

@end
MKPlacemark *the_placemark;

@implementation OfferRideDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set Self as delegate for search box
    //self.searchBar.delegate = self;
    
    // Might have to check if authorized to get location first
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    // Create Coordinate region that is 500 meter square around current location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 500, 500);
    
    // Set up the map view
    //self.mapView.showsUserLocation = true;
    self.mapView.delegate = self;
    [self.mapView setRegion:region animated:true];
    
    
    // Set up pin for current location
    self.pin = [[MKPointAnnotation alloc] init];
    self.pin.coordinate = self.locationManager.location.coordinate;
    
    // Display the pin on map
    [self.mapView addAnnotation:self.pin];

    NSLog(@"rde: %@", self.ride);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Update pin position everytime map position is changed
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.pin.coordinate = self.mapView.centerCoordinate;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:self.pin];
}

// Send on Ride object to next seague
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OfferRideStartSeague"]) {
        self.ride.endCordinate = self.pin.coordinate;
        OfferRideStartViewController *vc2 = (OfferRideStartViewController *)segue.destinationViewController;
        vc2.ride = self.ride;
        NSLog(@"Prepared for Seague OfferRideEndSeague");
    }
    
}


// Used for finding areas in vicinity
- (IBAction)SearchBox:(UITextField *)sender {
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = sender.text;
    request.region = _mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            for (MKMapItem *item in response.mapItems) {
                self.pin.coordinate = item.placemark.coordinate;
                break;
            }
            
        }
        MKCoordinateRegion region =MKCoordinateRegionMakeWithDistance (self.pin.coordinate, 500, 500);
        [self.mapView setRegion:region animated:YES];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:self.pin];
    }];

}
@end
