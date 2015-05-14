//
//  SelectConfirmationViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 14/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "SelectConfirmationViewController.h"
#import <AddressBookUI/AddressBookUI.h>


@interface SelectConfirmationViewController () {
    MKPolyline *routeOverlay;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation SelectConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *driver = self.ride.drivers[self.ride.rowNumber];
    PFObject* offer = self.ride.rideOffers[self.ride.rowNumber];
    
    NSString *driverName = [NSString stringWithFormat:@"%@ %@", driver[@"Name"], driver[@"Surname"]];
    NSLog(@"%@", driverName);
    NSDate* date = offer[@"dateTimeStart"];
    
    NSLog(@"date for request: %@", date );
    
    // date formatting stuff
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM"];
    NSString* dateString = [dateFormatter stringFromDate:date];
    
    // time formatting stuff
    //NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:MM"];
    NSString* timeString = [dateFormatter stringFromDate:date];
    NSLog(timeString);
    
    
    self.driverName.text = driverName;
    self.date.text = dateString;
    self.time.text = timeString;
    
    PFFile *userImageFile = driver[@"ProfilePicture"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.profileImage.image = [UIImage imageWithData:imageData];
        }
    }];
    
    [self getPickUpAddressFromCoordinates:self.ride.startCordinate];
    [self getDestAddressFromCoordinates:self.ride.endCordinate];
    [self getARoute:self.ride.startCordinate endCordinate:self.ride.endCordinate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/* METHODS FOR getting Address */
    
- (void) getPickUpAddressFromCoordinates:(CLLocationCoordinate2D)coordinates {
    CLLocation *location = [[CLLocation alloc] initWithLatitude: coordinates.latitude longitude:coordinates.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            NSLog(@"Geocode failed with error: %@", error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            //self.pickupAddress.text = [NSString stringWithFormat:@"%@", placemark.postalCode];
            self.pickupLocation.text = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            NSLog(@"%@", placemark.postalCode);
        }
    }];
}


- (void) getDestAddressFromCoordinates:(CLLocationCoordinate2D)coordinates {
    CLLocation *location = [[CLLocation alloc] initWithLatitude: coordinates.latitude longitude:coordinates.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            NSLog(@"Geocode failed with error: %@", error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            //self.pickupAddress.text = [NSString stringWithFormat:@"%@", placemark.postalCode];
            self.destinationLocation.text = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            NSLog(@"%@", placemark.postalCode);
        }
    }];
}

- (void)getARoute:(CLLocationCoordinate2D)startCo endCordinate:(CLLocationCoordinate2D)endCo {
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    
    
    
    MKPlacemark *start = [[MKPlacemark alloc] initWithCoordinate:startCo addressDictionary:nil];
    MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:endCo addressDictionary:nil];
    
    [self.map addAnnotation:start];
    [self.map addAnnotation:end];
    
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
    regionCoord.latitude = startCo.latitude + ((endCo.latitude - startCo.latitude)/2);
    
    regionCoord.longitude = startCo.longitude + ((endCo.longitude - startCo.longitude)/2);
    
    
    MKPlacemark *regionPlace = [[MKPlacemark alloc] initWithCoordinate:regionCoord addressDictionary:nil];
    
    MKCoordinateRegion region;
    region.center = regionPlace.coordinate;
    if (endCo.latitude > startCo.latitude) {
        region.span.latitudeDelta = (endCo.latitude - startCo.latitude) * 1.2;
    } else {
        region.span.latitudeDelta = (startCo.latitude - endCo.latitude) * 1.2;
    }
    if (endCo.longitude > startCo.longitude) {
        region.span.longitudeDelta = (endCo.longitude - startCo.longitude) * 1.2;
    } else {
        region.span.longitudeDelta = (startCo.longitude -  endCo.longitude) * 1.2;
    }
    
    [self.map setRegion:region animated:YES];
    
}

-(void)plotRouteOnMap:(MKRoute *)route
{
    if (routeOverlay) {
        [self.map removeOverlay:routeOverlay];
    }
    routeOverlay = route.polyline;
    
    [self.map addOverlay:routeOverlay];
    
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return renderer;
    
}


- (IBAction)submitRequest:(UIButton *)sender {
    [self.activityView startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    [self.ride offerRideToCloudWithBlock:^(BOOL success, NSError * error) {
                
        // creat alert view controller to display upload information
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request Ride" message:@"Success" preferredStyle:UIAlertControllerStyleAlert];
        
        // stays on page
        UIAlertAction* retry = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        // goesback to dashboard view controller
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Dashboard" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self performSegueWithIdentifier:@"unwindToDashBoard" sender:self];
        }];
        
        if(!success) {
            alert.message = @"Could not upload to server, please check your internet connection and try again";
            
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
        
    }];
}
@end
