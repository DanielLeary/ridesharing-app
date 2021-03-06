//
//  SelectOfferViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 13/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "SelectOfferViewController.h"
#import "RequestRideCell.h"
#import "SelectConfirmationViewController.h"


@interface SelectOfferViewController ()

@end

@implementation SelectOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Creates footer that hides empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
    // Display drivers username
    cell.driver.text = [NSString stringWithFormat:@"%@ %@", driver[@"Name"], driver[@"Surname"]];
    
    // Display distance to driver start location
    PFGeoPoint* driverStart = offer[@"start"];
    CLLocationCoordinate2D driverCoordinate;
    driverCoordinate.latitude = driverStart.latitude;
    driverCoordinate.longitude = driverStart.longitude;
    cell.distance.text = [NSString stringWithFormat:@"%0.1f Miles", [Ride distanceBetweenCoordinates:self.ride.startCordinate secondCordinate:driverCoordinate]];
    
    
    // Display profile picture to screen
    PFFile *userImageFile = driver[@"ProfilePicture"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.profile.image = [UIImage imageWithData:imageData];
        }
    }];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.ride.rowNumber = (int)indexPath.row;
    [self performSegueWithIdentifier:@"SelectConfirmationSegue" sender:self];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SelectConfirmationSegue"]) {
        SelectConfirmationViewController *vc = (SelectConfirmationViewController*)segue.destinationViewController;
        vc.ride = self.ride;
    }    
}




@end
