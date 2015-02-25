//
//  ViewController.m
//  RideSharingMap
//
//  Created by Vaneet Mehta on 08/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

MKRoute *routeDetails;
//CLPlacemark *destination;
MKPolyline *routeOverlay;
MKPlacemark *the_placemark;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    _mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToCurrentLocation:(UIBarButtonItem *)sender {
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 500, 500);
    [_mapView setRegion:region animated:YES];
}

- (IBAction)doASearch:(UIBarButtonItem *)sender {
    MKPointAnnotation *imperial = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D imperialCoordinate;
    imperialCoordinate.latitude = 51.500505;
    imperialCoordinate.longitude = -0.178219;
    imperial.coordinate = imperialCoordinate;
    MKCoordinateRegion region =MKCoordinateRegionMakeWithDistance (imperial.
                                            coordinate,
                                            500, 500);
    [_mapView setRegion:region animated:YES];
    [self.mapView addAnnotation:imperial];
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

- (IBAction)getARoute:(UIBarButtonItem *)sender {
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    
    /*
    CLLocationCoordinate2D sourceCoordinate;
    sourceCoordinate.latitude = 51.535951;
    sourceCoordinate.longitude = -0.461909;
    
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoordinate addressDictionary:nil];
    
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    
    CLLocationCoordinate2D destinationCoordinate;
    destinationCoordinate.latitude = 51.500505;
    destinationCoordinate.longitude = -0.178219;
    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoordinate addressDictionary:nil];
    */
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:the_placemark];
    
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    
    [directionsRequest setDestination:destination];
    
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
            return;
        } else {
            routeDetails = [response.routes firstObject];
            [self plotRouteOnMap:routeDetails];
        }
        
    }];
    CLLocationCoordinate2D regionCoord;
    regionCoord.latitude = self.locationManager.location.coordinate.latitude + ((the_placemark.coordinate.latitude - self.locationManager.location.coordinate.latitude)/2);
    
    regionCoord.longitude = self.locationManager.location.coordinate.longitude + ((the_placemark.coordinate.longitude - self.locationManager.location.coordinate.longitude)/2);
    
    MKPlacemark *regionPlace = [[MKPlacemark alloc] initWithCoordinate:regionCoord addressDictionary:nil];
    
    MKCoordinateRegion region =MKCoordinateRegionMakeWithDistance (regionPlace.
                                            coordinate,
                                            20000, 20000);
    
    //MKCoordinateRegion region;
    //region.center = regionPlace.coordinate;
    //region.span = MKCoordinateSpanMake(1.00000725, 1.00000725);
    [self.mapView setRegion:region animated:YES];
    
}

- (IBAction)SearchBox:(UITextField *)sender {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:sender.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            the_placemark = [[MKPlacemark alloc] initWithPlacemark:placemark];
            /*
            float spanX = 0.00725;
            float spanY = 0.00725;
            
            MKCoordinateRegion region;
            region.center.latitude = placemark.location.coordinate.latitude;
            region.center.longitude = placemark.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            [self.mapView setRegion:region animated:YES];
             
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.l = placemark.location;
             */
            MKCoordinateRegion region =MKCoordinateRegionMakeWithDistance (the_placemark.coordinate,
                                                    500, 500);
            [self.mapView setRegion:region animated:YES];
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView addAnnotation:the_placemark];
            
        }
    }];
}

@end
