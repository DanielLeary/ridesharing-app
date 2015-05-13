//
//  AddPlaceViewController.m
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "AddPlaceViewController.h"



@interface AddPlaceViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) MKPointAnnotation *pin;

@end


@implementation AddPlaceViewController{
    UserViewModel *viewModel;
}


/* FUNCTIONS FOR VIEW CONFIGURATION */

- (void)viewDidLoad {
    
    UserModel *user = [[UserModel alloc] init];
    viewModel = [[UserViewModel alloc] initWithModel:user];
    [super viewDidLoad];
    
    // set textField delegates for keyboard functions
    self.placeNameField.delegate = self;
    self.placeLocationField.delegate = self;
    
    // set up locationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    // set up mapView
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    // set up annotation pin
    self.pin = [[MKPointAnnotation alloc] init];
    
    //zoom to current location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 500, 500);
    MKCoordinateRegion adjustRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjustRegion animated:YES];
    
    // add pin to center of map
    self.pin.coordinate = CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude);
    [self.mapView addAnnotation:self.pin];
}

- (void)viewDidAppear:(BOOL)animated {
    // show keyboard
    [self.placeNameField becomeFirstResponder];
    // TODO move the pic and location setting into this method
}


/* METHODS FOR UI RESPONSES */

- (IBAction)saveButtonPressed:(id)sender {
    if (self.placeNameField.text.length!=0) {
        NSString *placeName         = self.placeNameField.text;
        CLLocationDegrees latitude  = self.pin.coordinate.latitude;
        CLLocationDegrees longitude = self.pin.coordinate.longitude;
        CLLocationCoordinate2D placeCoords = CLLocationCoordinate2DMake(latitude, longitude);
        Place *place = [[Place alloc] initWithName:placeName andCoordinates:placeCoords];
        
        //if place is being edited
        if (self.editing==YES) {
            [viewModel replacePlaceAtIndex:self.placeIndexPath withPlace:place];
            [self.navigationController popViewControllerAnimated:YES];
        //if place is being added
        } else {
            [viewModel addPlace:place];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        //set placeNameField red and return keyboard
        [self.placeNameField setBackgroundColor:[UIColor redColor]];
        [self.placeNameField becomeFirstResponder];
    }
}

- (IBAction)searchEntered:(UITextField *)sender {
    // create local search request
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
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (self.pin.coordinate, 500, 500);
        [self.mapView setRegion:region animated:YES];
    }];
}



/* MAP FUNCTIONS */

// always set pin to map center
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.pin.coordinate = CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
}


/* KEYBOARD FUNCTIONS */

//dismiss keyboard on done button
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField==_placeNameField) {
        [_placeLocationField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

//dismiss keyboard on touch outside
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


@end
