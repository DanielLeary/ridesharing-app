//
//  OfferRideFinishViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 20/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "OfferRideDestinationViewController.h"
#import "RequestRideCompleteViewController.h"
#define MAX_FAV 4


@interface OfferRideDestinationViewController ()

@property (strong, atomic)  CLLocationManager* locationManager;
@property (strong, atomic)  MKPointAnnotation* pin;
@property (weak, nonatomic) IBOutlet UINavigationItem *NavTitle;


@end
MKPlacemark *the_placemark;

@implementation OfferRideDestinationViewController{
    User* user;
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
    
    // Might have to check if authorized to get location first
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    
    // Set up pin annotation
    self.pin = [[MKPointAnnotation alloc] init];
    
    // If user location isn't available, set to default view, view of England
    if (self.locationManager.location == nil) {
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
    }
    
}

- (IBAction)favouritesActionSheet:(id)sender {
    int maxP = (int)[User getFavPlacesCount];
    int max = maxP < MAX_FAV ? maxP : MAX_FAV;
    
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


// Used for finding areas in vicinity
- (IBAction)SearchBox:(UITextField *)sender {
    
    // create local search request
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = sender.text;
    request.region = _mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            
            // Get the first result and break
            for (MKMapItem *item in response.mapItems) {
                self.pin.coordinate = item.placemark.coordinate;
                break;
            }
            
        }
        
        // Change region view with the searched place in the center
        MKCoordinateRegion region =MKCoordinateRegionMakeWithDistance (self.pin.coordinate, 500, 500);
        [self.mapView setRegion:region animated:YES];
        
    }];

}

- (IBAction)locationButton:(UIButton *)sender {
    
    // If location isn't available, then do nothing
    if (self.locationManager.location == nil) {
        return;
    }
    
    // Change region view with user location in the center
    CLLocation* userLocation = _locationManager.location;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500);
    [_mapView setRegion:region animated:YES];
}

- (IBAction)selecFav:(id)sender {
}


- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    
        // Get location from the viewpoint
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        
        // Convert to coordinates
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        // Setting up the annotation
        MKPointAnnotation *pressed = [[MKPointAnnotation alloc] init];
        pressed.coordinate = touchMapCoordinate;
        
        // changing the region with this point in the center
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (pressed.coordinate, 500, 500);
        [self.mapView setRegion:region animated:YES];
        

    }
}

@end
