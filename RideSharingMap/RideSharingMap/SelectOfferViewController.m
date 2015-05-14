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
    //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    return ([self.ride.rideOffers count]==0) ? 1 : [self.ride.rideOffers count];
    //return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if ([self.ride.rideOffers count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
        cell.textLabel.text = @"No rides available :(";
        return cell;
        
    } else {
        // Populate Table view with data
        RequestRideCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RequestRideCell"];
        PFObject* object = self.ride.rideOffers[indexPath.row];
        PFUser* driver = [object objectForKey:@"driver"];
        cell.name.text = [NSString stringWithFormat:@"%@ %@", driver[@"name"], driver[@"surname"]];
        PFFile* userImage = driver[@"ProfilePicture"];
        [userImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                cell.profileImage.image = [UIImage imageWithData:imageData];
            }
        }];
        PFGeoPoint* driverLoc = object[@"start"];
        CLLocationCoordinate2D driverLocation;
        driverLocation.latitude = driverLoc.latitude;
        driverLocation.longitude = driverLoc.longitude;

        double distMiles = [Ride distanceBetweenCoordinates:driverLocation secondCordinate:self.ride.startCordinate];
        cell.distanceFromUser.text = [NSString stringWithFormat:@"%fl miles", distMiles];
        return cell;
    }
     */

    RequestRideCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    PFObject* object = self.ride.rideOffers[indexPath.row];
    PFUser* driver = [object objectForKey:@"driver"];
    cell.label.text = [NSString stringWithFormat:@"%@ %@", driver[@"name"], driver[@"surname"]];
    return cell;
}


@end
