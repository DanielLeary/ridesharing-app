//
//  RequestRideCompleteViewController.m
//  RideSharingMap
//
//  Created by Vaneet Mehta on 11/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "RequestRideCompleteViewController.h"

@interface RequestRideCompleteViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;


@end

@implementation RequestRideCompleteViewController

MKPolyline *routeOverlay = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"rde: %@", self.request);
    
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
    
    MKPlacemark *start = [[MKPlacemark alloc] initWithCoordinate:self.request.startCordinate addressDictionary:nil];
    
    MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:self.request.endCordinate addressDictionary:nil];
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
    regionCoord.latitude = self.request.startCordinate.latitude + ((self.request.endCordinate.latitude                                            - self.request.startCordinate.latitude)/2);
    
    regionCoord.longitude = self.request.startCordinate.longitude + ((self.request.endCordinate.longitude - self.request.startCordinate.longitude)/2);
    
    
    MKPlacemark *regionPlace = [[MKPlacemark alloc] initWithCoordinate:regionCoord addressDictionary:nil];
    
    MKCoordinateRegion region;
    region.center = regionPlace.coordinate;
    if (self.request.endCordinate.latitude > self.request.startCordinate.latitude) {
        region.span.latitudeDelta = (self.request.endCordinate.latitude - self.request.startCordinate.latitude) * 1.2;
    } else {
        region.span.latitudeDelta = (self.request.startCordinate.latitude - self.request.endCordinate.latitude) * 1.2;
    }
    if (self.request.endCordinate.longitude > self.request.startCordinate.longitude) {
        region.span.longitudeDelta = (self.request.endCordinate.longitude - self.request.startCordinate.longitude) * 1.2;
    } else {
        region.span.longitudeDelta = (self.request.startCordinate.longitude -  self.request.endCordinate.longitude) * 1.2;
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



- (IBAction)finishButton {
    //Start spinning and don't allow interaction
    //[self.activityView startAnimating];
    //[self.view setUserInteractionEnabled:NO];
    //[self navigationController setUserInteractionEnabled:NO];
    
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
                //[self performSegueWithIdentifier:@"unwindToDashBoard" sender:self];
            }];
            [alert addAction:retry];
            [alert addAction:cancel];
        } else {
            UIAlertAction* OK = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"OK Pressed");
                //[self performSegueWithIdentifier:@"unwindToDashBoard" sender:self];
            }];
            [alert addAction:OK];
        }
        
        // Stop spinning, enable interaction, show alert on screen
        //[self.activityView stopAnimating];
        //[self.view setUserInteractionEnabled:YES];
        [self presentViewController:alert animated:YES completion:nil];
        
    };
    
    [self.request uploadToCloudWithBlock:displayInfoBlock];
}
@end
