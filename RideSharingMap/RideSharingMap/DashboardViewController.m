//
//  DashboardViewController.m
//  RideSharingMap
//
//  Created by Daniel Leary on 26/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "DashboardViewController.h"
#import "OfferRideTimeViewController.h"
#import "Ride.h"


@implementation DashboardViewController {
    
    User *user;
    NSArray *journeysTableData;
    BOOL emptyTable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    user = (User *)[PFUser currentUser];
    emptyTable = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidAppear:(BOOL)animated {
    // Get journeys that user is involved in as either driver or passenger
    PFQuery *query1 = [PFQuery queryWithClassName:JOURNEY];
    [query1 whereKey:J_PASSENGER equalTo:user];
    PFQuery *query2 = [PFQuery queryWithClassName:JOURNEY];
    [query2 whereKey:J_DRIVER equalTo:user];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    [query includeKey:J_DRIVER];
    [query includeKey:J_PASSENGER];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            journeysTableData = objects;
            //reloads tableview after asynchronous call complete
            emptyTable = ([journeysTableData count]==0);
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([journeysTableData count]==0) ? 1 : [journeysTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (emptyTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
        cell.textLabel.text = @"No journeys (yet)";
        return cell;
        
    } else {
        PFObject *journeyObject = journeysTableData[indexPath.row];
        
        PFUser *driver = [journeyObject objectForKey:R_DRIVER];
        PFUser *passenger = [journeyObject objectForKey:R_PASSENGER];
        
        NSDate *date = journeyObject[J_TIME];
    
        // check if user is the driver
        if ([user.objectId isEqualToString:driver.objectId]) {
            GivingRideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"givingRideCell"];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", passenger[Pfirstname], passenger[Plastname]];
            PFFile *imageFile = passenger[Ppicture];
            [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    cell.profilePicture.image = [UIImage imageWithData:imageData];
                } else {
                    cell.profilePicture.image = [UIImage imageWithContentsOfFile:blankProfIm];
                }
            }];
        
            // date formatting stuff
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, d MMM"];
            cell.dateLabel.text = [dateFormatter stringFromDate:date];
    
            // time formatting stuff
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"HH:mm"];
            cell.timeLabel.text = [timeFormatter stringFromDate:date];

            return cell;
    
        // user is getting a ride from driver
        } else if ([user.objectId isEqualToString:passenger.objectId]) {
            GettingRideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gettingRideCell"];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", driver[Pfirstname], driver[Plastname]];
            PFFile *imageFile = driver[Ppicture];
            [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    cell.profilePicture.image = [UIImage imageWithData:imageData];
                } else {
                    cell.profilePicture.image = [UIImage imageWithContentsOfFile:blankProfIm];
                }
            }];
        
            // date formatting stuff
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, d MMM"];
            cell.dateLabel.text = [dateFormatter stringFromDate:date];
    
            // time formatting stuff
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"HH:mm"];
            cell.timeLabel.text = [timeFormatter stringFromDate:date];

            return cell;
        } else {
            return [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    JourneyView *journeyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"JourneyView"];
    PFObject *journey = journeysTableData[indexPath.row];
    journeyVC.item = journey;
    [journeyVC view];

    PFUser *driver = journey[J_DRIVER];
    PFUser *passenger = journey[J_PASSENGER];
    
    //user is the driver
    if ([user.objectId isEqualToString:driver.objectId]) {
        GivingRideCell *cell = (GivingRideCell *)[tableView cellForRowAtIndexPath:indexPath];
        //set info for next viewController
        journeyVC.navigationItem.title = @"Journey";
        journeyVC.name.text = cell.nameLabel.text;
        journeyVC.date.text = cell.dateLabel.text;
        journeyVC.time.text = cell.timeLabel.text;
        journeyVC.image.image = cell.profilePicture.image;
        journeyVC.give_get.text = @"Giving a ride to";
        [self.navigationController pushViewController:journeyVC animated:YES];
    
    //user is the passenger
    } else if ([user.objectId isEqualToString:passenger.objectId]) {
        GettingRideCell *cell = (GettingRideCell *)[tableView cellForRowAtIndexPath:indexPath];
        //set info for next viewController
        journeyVC.navigationItem.title = @"Journey";
        journeyVC.name.text = cell.nameLabel.text;
        journeyVC.date.text = cell.dateLabel.text;
        journeyVC.time.text = cell.timeLabel.text;
        journeyVC.image.image = cell.profilePicture.image;
        journeyVC.give_get.text = @"Getting a ride from";
        [self.navigationController pushViewController:journeyVC animated:YES];
    }
}


/* METHODS TO POP SEQUES */

- (IBAction)unWindFromOfferView:(UIStoryboardSegue *)segue {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDate * today = [NSDate date];
    Ride* ride = [[Ride alloc] initWithDate:today];
    ride.user = [PFUser currentUser];
    
    if([segue.identifier  isEqual: @"OfferRideSeague"]) {
        ride.offerRide = TRUE;
        OfferRideTimeViewController* vc = (OfferRideTimeViewController*)segue.destinationViewController;
        vc.ride = ride;
    }
    
    if([segue.identifier  isEqual: @"RequestRideSeague"]) {
        ride.offerRide = FALSE;
        OfferRideTimeViewController* vc = (OfferRideTimeViewController*)segue.destinationViewController;
        vc.ride = ride;
    }
}



@end
