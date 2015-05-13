//
//  RequestRideCompleteViewController.m
//  RideSharingMap
//
//  Created by Vaneet Mehta on 11/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "RequestRideCompleteViewController.h"
#import "SelectOfferViewController.h"

@interface RequestRideCompleteViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;



@end

@implementation RequestRideCompleteViewController

MKPolyline *routeOverlay = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.ride.offerRide) {
        [_buttonLabel setTitle:@"Finish" forState:normal];
        _navTitle.title = @"Offer Ride";
    } else {
        [_buttonLabel setTitle:@"Next" forState:normal];
        _navTitle.title = @"Request Ride";
    }
    
    NSLog(@"rde: %@", self.ride);
    
    [UIActivityIndicatorView appearance];
    self.mapView.delegate = self;
    [self getARoute];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getARoute {
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    
    MKPlacemark *start = [[MKPlacemark alloc] initWithCoordinate:self.ride.startCordinate addressDictionary:nil];
    
    MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:self.ride.endCordinate addressDictionary:nil];
    [self.mapView addAnnotation:start];
    [self.mapView addAnnotation:end];
    
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:start];
    
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:end];
    
    [directionsRequest setSource:source];
    [directionsRequest setDestination:destination];
    
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
            return;
        } else {
            MKRoute *routeDetails = [response.routes firstObject];
            [self plotRouteOnMap:routeDetails];
        }
        
    }];
    CLLocationCoordinate2D regionCoord;
    regionCoord.latitude = self.ride.startCordinate.latitude + ((self.ride.endCordinate.latitude                                            - self.ride.startCordinate.latitude)/2);
    
    regionCoord.longitude = self.ride.startCordinate.longitude + ((self.ride.endCordinate.longitude - self.ride.startCordinate.longitude)/2);
    
    
    MKPlacemark *regionPlace = [[MKPlacemark alloc] initWithCoordinate:regionCoord addressDictionary:nil];
    
    MKCoordinateRegion region;
    region.center = regionPlace.coordinate;
    if (self.ride.endCordinate.latitude > self.ride.startCordinate.latitude) {
        region.span.latitudeDelta = (self.ride.endCordinate.latitude - self.ride.startCordinate.latitude) * 1.2;
    } else {
        region.span.latitudeDelta = (self.ride.startCordinate.latitude - self.ride.endCordinate.latitude) * 1.2;
    }
    if (self.ride.endCordinate.longitude > self.ride.startCordinate.longitude) {
        region.span.longitudeDelta = (self.ride.endCordinate.longitude - self.ride.startCordinate.longitude) * 1.2;
    } else {
        region.span.longitudeDelta = (self.ride.startCordinate.longitude -  self.ride.endCordinate.longitude) * 1.2;
    }
    
    [self.mapView setRegion:region animated:YES];
    
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return renderer;
    
}

-(void)plotRouteOnMap:(MKRoute *)route
{
    if (routeOverlay) {
        [self.mapView removeOverlay:routeOverlay];
    }
    routeOverlay = route.polyline;
    
    [self.mapView addOverlay:routeOverlay];
    
}


- (IBAction)finishButton{
    
    //Start spinning and don't allow interaction
    [self.activityView startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    //Set the start location to current pin location
    //self.ride.startCordinate = self.pin.coordinate;
    
    
    
    
    
    // Run if offering a ride
    if (self.ride.offerRide) {
        
        // This block runs after parse completes or fails upload to cloud
        void(^displayInfoBlock)(BOOL, NSError*) = ^(BOOL succeded, NSError* error){
            
            // creat alert view controller to display upload information
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Offer Ride" message:@"Success" preferredStyle:UIAlertControllerStyleAlert];
            
            // stays on page
            UIAlertAction* retry = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            
            // goesback to dashboard view controller
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Dashboard" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self performSegueWithIdentifier:@"unwindToDashBoard" sender:self];
            }];
            
            if(!succeded) {
                alert.message = @"Could not upload to server, please check your internet connection and try again";
                
                // stays on page
                //UIAlertAction* retry = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                
                // goes back to DashBoardViewController
                //UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Dashboard" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //        [self performSegueWithIdentifier:@"unwindToDashBoard" sender:self];
                //    }];
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
    } else {
        // Block of code to execute once query has returned from parse.
        [self performSegueWithIdentifier:@"SelectOfferSegue" sender:self];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SelectOfferSegue"]) {
        SelectOfferViewController* vc = (SelectOfferViewController*)segue.destinationViewController;
        vc.ride = self.ride;
    }
}

@end
