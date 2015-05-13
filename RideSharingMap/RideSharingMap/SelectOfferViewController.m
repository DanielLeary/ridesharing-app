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
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self queryOffersTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TABLE METHODS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self.ride.rideOffers count]==0) ? 1 : [self.ride.rideOffers count];
}

- (void)queryOffersTable {
    void(^retrieveObjBlock)(BOOL, NSError*) = ^(BOOL success, NSError* error) {
        // run if requesting ride
        if (success) {
            
            NSLog(@"Success in retrieving block");
            NSLog(@"Size of results: %lu", (unsigned long)[self.ride.rideOffers count]);
            PFObject* offer = self.ride.rideOffers[0];
            PFUser* driver = [offer objectForKey:@"driver"];
            for (PFObject* object in self.ride.rideOffers) {
                NSLog(@"found %@", object.objectId);
                //driver = [object objectForKey:@"driver"];
            }
            
            // print out name of driver
            NSLog(@"Name of driver is: %@ %@", driver[@"Name"], driver[@"Surname"]);
            
            // Print out object id
            NSLog(@"Object memory address: %p", self.ride.rideOffers);
            
            // Reload table
            [self.tableView reloadData];
            
        } else {
            
            // Display alert that couldn't upload
            NSString* string = @"Could not connect to server, please check your internet connection and try again";
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request Ride" message:string preferredStyle:UIAlertControllerStyleAlert];
            // stays on page
            UIAlertAction* retry = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            
            // goesback to dashboard view controller
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Dashboard" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
             {
                 [self performSegueWithIdentifier:@"unwindToDashBoard" sender:self];
             }];

            [alert addAction:retry];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        //[self.activityView stopAnimating];
        [self.view setUserInteractionEnabled:YES];
        
        
    };
    
    [self.ride queryRidesWithBlock:retrieveObjBlock];
    
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
     

    RequestRideCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    PFObject* object = self.ride.rideOffers[indexPath.row];
    PFUser* driver = [object objectForKey:@"driver"];
    cell.label.text = [NSString stringWithFormat:@"%@ %@", driver[@"name"], driver[@"surname"]];
    return cell;
} */


@end
