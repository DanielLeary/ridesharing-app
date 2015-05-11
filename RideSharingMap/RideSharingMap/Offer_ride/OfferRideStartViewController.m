//
//  OfferRideStartViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "OfferRideStartViewController.h"
#import "OfferRideDestinationViewController.h"



@interface OfferRideStartViewController ()

@property (strong, atomic) CLLocationManager* locationManager;
@property (strong, atomic) MKPointAnnotation* pin;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation OfferRideStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Might have to check if authorized to get location first
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    // Set up the map view
    //self.mapView.showsUserLocation = true;
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
        
    
        // Create Coordinate region that is 500 meter square around current location
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 500, 500);
        [self.mapView setRegion:region animated:true];
    
        // Set up pin for current location
        self.pin = [[MKPointAnnotation alloc] init];
        self.pin.coordinate = self.locationManager.location.coordinate;
    
        // Display the pin on map
        [self.mapView addAnnotation:self.pin];
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

- (IBAction)finishButton{
    
    //Start spinning and don't allow interaction
    [self.activityView startAnimating];
    [self.view setUserInteractionEnabled:NO];
    //[self navigationController setUserInteractionEnabled:NO];
    
    //Set the start location to current pin location
    self.ride.startCordinate = self.pin.coordinate;
    
    // This block runs after parse completes or fails upload to cloud
    void(^displayInfoBlock)(BOOL, NSError*) = ^(BOOL succeded, NSError* error){
        
        // creat alert view controller to display upload information
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Offer Ride" message:@"Success" preferredStyle:UIAlertControllerStyleAlert];
        
        if(!succeded) {
            alert.message = @"Could not upload to server, please check your internet connection and try again";
            
            // stays on page
            UIAlertAction* retry = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            
            // goes back to DashBoardViewController
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Dashboard" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self performSegueWithIdentifier:@"unwindToDashBoard" sender:self];
                }];
            [alert addAction:retry];
            [alert addAction:cancel];
        } else {
            UIAlertAction* OK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"OK Pressed");
                [self performSegueWithIdentifier:@"unwindToDashBoard" sender:self];
            }];
            [alert addAction:OK];
        }
        
        // Stop spinning, enable interaction, show alert on screen
        [self.activityView stopAnimating];
        [self.view setUserInteractionEnabled:YES];
        [self presentViewController:alert animated:YES completion:nil];

    };
    
    [self.ride uploadToCloudWithBlock:displayInfoBlock];
    
    
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
