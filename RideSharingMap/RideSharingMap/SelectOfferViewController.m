//
//  SelectOfferViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 13/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "SelectOfferViewController.h"
#import "RequestRideCell.h"
//#import "TableViewCell.h"

@interface SelectOfferViewController ()

@end

@implementation SelectOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Creates footer that hides empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSLog(@"Ride object memory address: %p", self.ride);
    // Print out object id
    NSLog(@"Object memory address: %p", self.ride.rideOffers);
    // Print out offer rides
    NSLog(@"Size of results: %lu", (unsigned long)[self.ride.rideOffers count]);
    for (PFObject* object in self.ride.rideOffers) {
        NSLog(@"found %@", object.objectId);
    }
    
    NSLog(@"Size of Drivers: %lu", (unsigned long) [self.ride.drivers count]);
    for (PFUser* driver in self.ride.drivers) {
        NSLog(@"Name of driver is: %@ %@", driver[@"Name"], driver[@"Surname"]);
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    //[self queryOffersTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TABLE METHODS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ride.rideOffers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RequestRideCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RequestRideCell"];
    PFObject* offer = self.ride.rideOffers[indexPath.row];
    PFUser* driver = self.ride.drivers[indexPath.row];
    NSLog(@"Driver: %@ %@", driver[@"Name"], driver[@"Surname"]);
    cell.driver.text = [NSString stringWithFormat:@"%@ %@", driver[@"Name"], driver[@"Surname"]];
    PFGeoPoint* driverStart = offer[@"start"];
    CLLocationCoordinate2D driverCoordinate;
    driverCoordinate.latitude = driverStart.latitude;
    driverCoordinate.longitude = driverStart.longitude;
    cell.distance.text = [NSString stringWithFormat:@"%0.1f Miles", [Ride distanceBetweenCoordinates:self.ride.startCordinate secondCordinate:driverCoordinate]];
    
    return cell;
}


@end
