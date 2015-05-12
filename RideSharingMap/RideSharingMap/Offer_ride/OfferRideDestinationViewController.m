//
//  OfferRideFinishViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 20/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "OfferRideDestinationViewController.h"
#import "RequestRideCompleteViewController.h"


@interface OfferRideDestinationViewController ()

@property (strong, atomic) CLLocationManager* locationManager;
@property (strong, atomic) MKPointAnnotation* pin;
@property (weak, nonatomic) IBOutlet UINavigationItem *NavTitle;


@end
MKPlacemark *the_placemark;

@implementation OfferRideDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up UINavbar Item
    if (self.ride.offerRide) {
        self.NavTitle.title = @"Offer Ride";
    } else {
        self.NavTitle.title = @"Request Ride";
    }
    
    
    // Might have to check if authorized to get location first
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    self.mapView.delegate = self;
    if (self.locationManager.location == nil) {
        NSLog(@"region!!: %@", nil);
        CLLocationCoordinate2D start_place = CLLocationCoordinate2DMake(54.1108, -3.2261);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(start_place, 1000000, 1000000);
        [self.mapView setRegion:region animated:true];
        self.pin = [[MKPointAnnotation alloc] init];
        self.pin.coordinate = CLLocationCoordinate2DMake(54.1108, -3.2261);
        [self.mapView addAnnotation:self.pin];
    } else {
        NSLog(@"region??: %@", self.locationManager.location);
    // Create Coordinate region that is 500 meter square around current location
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 500, 500);
        [self.mapView setRegion:region animated:true];
        self.pin = [[MKPointAnnotation alloc] init];
        self.pin.coordinate = self.locationManager.location.coordinate;
        
        // Display the pin on map
        [self.mapView addAnnotation:self.pin];
        
    }
    // Set up the map view
    //self.mapView.showsUserLocation = true;
        //[self.mapView setRegion:region animated:true];
    
    
    // Set up pin for current location
    //self.pin = [[MKPointAnnotation alloc] init];
    //self.pin.coordinate = self.locationManager.location.coordinate;
    
    // Display the pin on map
    //[self.mapView addAnnotation:self.pin];
    UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleGesture:)];
    lpgr.minimumPressDuration = .5; //seconds
    lpgr.delegate = self;
    [self.mapView addGestureRecognizer:lpgr];

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
    if ([segue.identifier isEqualToString:@"RideCompleteSeague"]) {
        self.ride.endCordinate = self.pin.coordinate;
        RequestRideCompleteViewController *vc2 = (RequestRideCompleteViewController *)segue.destinationViewController;
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

- (IBAction)locationButton:(UIButton *)sender {
    CLLocation* usrLocation = _locationManager.location;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(usrLocation.coordinate, 500, 500);
    [_mapView setRegion:region animated:YES];
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
    pa.coordinate = touchMapCoordinate;
    pa.title = @"Hello";
    [self.mapView addAnnotation:pa];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (pa.coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];

    //[pa release];
    }
}

@end
