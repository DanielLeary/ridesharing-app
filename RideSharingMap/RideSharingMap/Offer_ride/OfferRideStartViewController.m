//
//  OfferRideStartViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "OfferRideStartViewController.h"
#import "OfferRideDestinationViewController.h"
#import <Parse/Parse.h>



@interface OfferRideStartViewController ()

@property (strong, atomic) CLLocationManager* locationManager;
@property (strong, atomic) MKPointAnnotation* pin;
@property (weak, nonatomic) IBOutlet UINavigationItem *NavTitle;
@property (weak, nonatomic) IBOutlet UILabel *Descriptor;

@end

@implementation OfferRideStartViewController{
    User *user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    user = (User*)[PFUser currentUser];
    // Set up UINavbar Item
    if (self.ride.offerRide) {
        self.NavTitle.title = @"Offer Ride";
    } else {
        self.NavTitle.title = @"Request Ride";
    }
    
    // Set up label description
    if (self.ride.offerRide) {
        self.Descriptor.text = @"Choose a Departure Location";
    } else {
        self.Descriptor.text = @"Choose a Pick-up Point";
    }

    // Might have to check if authorized to get location first
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    // Set up the map view
    self.mapView.showsUserLocation = YES;
    
    self.mapView.delegate = self;
    
    self.pin = [[MKPointAnnotation alloc] init];
    
    if (self.locationManager.location == nil) {
        NSLog(@"region!!: %@", nil);
        CLLocationCoordinate2D start_place = CLLocationCoordinate2DMake(54.1108, -3.2261);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(start_place, 1000000, 1000000);
        [self.mapView setRegion:region animated:true];
       
    } else {
        
    
        // Create Coordinate region that is 500 meter square around current location
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 500, 500);
        [self.mapView setRegion:region animated:true];
    
        
    }
    UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleGesture:)];
    lpgr.minimumPressDuration = .5; //seconds
    lpgr.delegate = self;
    [self.mapView addGestureRecognizer:lpgr];
    
    // make activity view indicator big
    [UIActivityIndicatorView appearance];
}

-(void) viewDidAppear:(BOOL)animated {
    //[self.searchBar becomeFirstResponder];
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
    if (self.locationManager.location == nil) {
        return;
    }
    CLLocation* usrLocation = _locationManager.location;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(usrLocation.coordinate, 500, 500);
    [_mapView setRegion:region animated:YES];
}

- (IBAction)favouritesActionSheet:(id)sender {
    int maxP = (int)[User getFavPlacesCount];
    int max = maxP < 4 ? maxP : 4;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a location:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for (int i = 0; i < max; i++) {
        NSString* name = [[User getPlaceAtIndex:i] name];
        [actionSheet addButtonWithTitle:name];
    }
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
    
    
    
    Place* place = [User getPlaceAtIndex:(buttonIndex -1)];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(place.coordinates, 500, 500);
    [self.mapView setRegion:region animated:true];
    [self.mapView removeAnnotations:self.mapView.annotations];
    MKPlacemark* newplace = [[MKPlacemark alloc] initWithCoordinate:place.coordinates addressDictionary:nil ];
    [self.mapView addAnnotation:newplace];

    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OfferRideDestinationSeague"]) {
        self.ride.startCordinate = self.pin.coordinate;
        OfferRideDestinationViewController *vc2 = (OfferRideDestinationViewController *)segue.destinationViewController;
        vc2.ride = self.ride;
        NSLog(@"Prepared for Seague OfferRideDestinationSeague");
    }
    
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
