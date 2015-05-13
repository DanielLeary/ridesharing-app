//
//  JourneyView.m
//  RideSharingMap
//
//  Created by Daniel Leary on 12/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "JourneyView.h"
#import <AddressBookUI/AddressBookUI.h>


@implementation JourneyView {

    MKPolyline *routeOverlay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.map.delegate = self;
    
    NSArray *startc = _item[@"pickup"];
    CLLocationCoordinate2D startCoord;
    startCoord.latitude = [startc[0] doubleValue];
    startCoord.longitude = [startc[1] doubleValue];
    [self getPickUpAddressFromCoordinates:startCoord];
    
    NSArray *endc = _item[@"end"];
    CLLocationCoordinate2D endCoord;
    endCoord.latitude = [endc[0] doubleValue];
    endCoord.longitude = [endc[1] doubleValue];
    [self getDestAddressFromCoordinates:endCoord];
    
    
    [self getARoute];
    
    // Draw a line divider
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 140.0, 345.0, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite: 0.90 alpha:1];
    [self.view addSubview:lineView];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)getARoute {
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    
    
    NSArray *startc = _item[@"pickup"];
    CLLocationCoordinate2D startCoord;
    startCoord.latitude = [startc[0] doubleValue];
    startCoord.longitude = [startc[1] doubleValue];
    MKPlacemark *start = [[MKPlacemark alloc] initWithCoordinate:startCoord addressDictionary:nil];
    
    NSArray *endc = _item[@"end"];
    CLLocationCoordinate2D endCoord;
    endCoord.latitude = [endc[0] doubleValue];
    endCoord.longitude =  [endc[1] doubleValue];
    MKPlacemark *end = [[MKPlacemark alloc] initWithCoordinate:endCoord addressDictionary:nil];
    
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
    regionCoord.latitude = startCoord.latitude + ((endCoord.latitude                                            - startCoord.latitude)/2);
    
    regionCoord.longitude = startCoord.longitude + ((endCoord.longitude - startCoord.longitude)/2);
    
    
    MKPlacemark *regionPlace = [[MKPlacemark alloc] initWithCoordinate:regionCoord addressDictionary:nil];
    
    MKCoordinateRegion region;
    region.center = regionPlace.coordinate;
    if (endCoord.latitude > startCoord.latitude) {
        region.span.latitudeDelta = (endCoord.latitude - startCoord.latitude) * 1.2;
    } else {
        region.span.latitudeDelta = (startCoord.latitude - endCoord.latitude) * 1.2;
    }
    if (endCoord.longitude > startCoord.longitude) {
        region.span.longitudeDelta = (endCoord.longitude - startCoord.longitude) * 1.2;
    } else {
        region.span.longitudeDelta = (startCoord.longitude -  endCoord.longitude) * 1.2;
    }
    
    [self.map setRegion:region animated:YES];
    
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
        [self.map removeOverlay:routeOverlay];
    }
    routeOverlay = route.polyline;
    
    [self.map addOverlay:routeOverlay];
    
}

/* METHODS FOR GEOCODING */

- (void) getPickUpAddressFromCoordinates:(CLLocationCoordinate2D)coordinates {
    CLLocation *location = [[CLLocation alloc] initWithLatitude: coordinates.latitude longitude:coordinates.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            NSLog(@"Geocode failed with error: %@", error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            //self.pickupAddress.text = [NSString stringWithFormat:@"%@", placemark.postalCode];
            self.pickupAddress.text = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
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
            self.destAddress.text = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            NSLog(@"%@", placemark.postalCode);
        }
    }];
}



@end