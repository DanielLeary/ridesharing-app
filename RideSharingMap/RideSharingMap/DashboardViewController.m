//
//  DashboardViewController.m
//  RideSharingMap
//
//  Created by Daniel Leary on 26/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "DashboardViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Ride.h"
#import "OfferRideTimeViewController.h"

@implementation DashboardViewController {
    
    //NSArray *tableData;
    BOOL emptyTable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //tableData = [NSMutableArray arrayWithObjects:@"Christina Hicks", @"Kevin Smith", nil];
    
    // Creates footer that hides empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    emptyTable = YES;
    
    //--------------------------------------------------------
    // Test creating a journey object and sending it to parse
    //--------------------------------------------------------
    /*
    CLLocationDegrees lat = 51.4922470;
    CLLocationDegrees lon = -0.2060875;
    
    Journey *testJourney = [[Journey alloc] init];
    
    CLLocationCoordinate2D jstart = {lat,lon};
    testJourney.startCoordinate = jstart;
    
    lat = 51.498727;
    lon = -0.179115;
    CLLocationCoordinate2D jend = {lat,lon};
    testJourney.endCoordinate = jend;
    
    lat = 51.4945581;
    lon = -0.19848;
    CLLocationCoordinate2D jpickup = {lat,lon};
    testJourney.pickupCoordinate = jpickup;
    
    testJourney.driverusername = @"lhan";
    
    testJourney.passengerusername = @"danleary";
    
    testJourney.journeyDateTime = [NSDate date];
    
    [testJourney uploadToCloud];
    */
    
}


- (void)viewDidAppear:(BOOL)animated {
    //---------------------------------------------------------------------
    // Get journeys that user is involved in as either driver or passenger
    //---------------------------------------------------------------------
    
    //note: replace hardcoding of "lhan" with current user email
    PFUser *loggedinuser = [PFUser currentUser];
    NSString *user = loggedinuser[@"username"];
    NSLog(@"%@", user);

    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Journeys"];
    [query1 whereKey:@"passengerusername" equalTo:user];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Journeys"];
    [query2 whereKey:@"driverusername" equalTo:user];    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            // Do something with the found objects
            for (PFObject *object in objects) {
                //NSLog(@"Id is %@", object.objectId);
            }
            _tableData = objects;
            // reloads tableview after async call complete
            [self.tableView reloadData];
            emptyTable = ([_tableData count]==0);
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self->_tableData count]==0) ? 1 : [self->_tableData count]; //self->_tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (emptyTable) {
        NSLog(@"testing empty");
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
        cell.textLabel.text = @"No journeys (yet)";
        return cell;
    }
    
    //replace hardcoding with call to PFUser object here
    PFUser *loggedinuser = [PFUser currentUser];
    NSString *user = loggedinuser[@"username"];
    NSLog(@"%@", user);

    //NSString *user = @"lhan";
    PFObject *item = _tableData[indexPath.row];
    NSString *driverusername = item[@"driverusername"];
    NSString *passengerusername = item[@"passengerusername"];
    NSDate *date = item[@"journeyDateTime"];
    
    // check if user is the driver
    if ([user isEqualToString:driverusername]) {
        GivingRideCell *cell = [tableView
                                dequeueReusableCellWithIdentifier:@"givingRideCell"];
        
        // query user table for name
        if (passengerusername != NULL) {
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" equalTo:passengerusername];
            [query findObjectsInBackgroundWithBlock:^(NSArray *result, NSError *error) {
                PFUser *person = result[0];
                NSString *forename = person[@"Name"];
                NSString *surname = person[@"Surname"];
                cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", forename, surname];
                
                PFFile *userImageFile = person[@"ProfilePicture"];
                [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        cell.profilePicture.image = [UIImage imageWithData:imageData];
                    }
                }];
            }];
            
        }
        
        
        // date formatting stuff
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, d MMM"];
        cell.dateLabel.text = [dateFormatter stringFromDate:date];
        
        // time formatting stuff
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:MM"];
        cell.timeLabel.text = [timeFormatter stringFromDate:date];
        
        
        return cell;
    
    // else user is getting a ride from driver
    } else {
        GettingRideCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:@"gettingRideCell"];
        
        // query user table for name
        if (driverusername != NULL) {
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" equalTo:driverusername];
            [query findObjectsInBackgroundWithBlock:^(NSArray *result, NSError *error) {
                PFUser *person = result[0];
                NSString *forename = person[@"Name"];
                NSString *surname = person[@"Surname"];
                cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", forename, surname];
            
                PFFile *userImageFile = person[@"ProfilePicture"];
                [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        cell.profilePicture.image = [UIImage imageWithData:imageData];
                    }
                }];
            }];
        }
        
        // date formatting stuff
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE, d MMM"];
        cell.dateLabel.text = [dateFormatter stringFromDate:date];
        
        // time formatting stuff
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:MM"];
        cell.timeLabel.text = [timeFormatter stringFromDate:date];

        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    JourneyView *journey = [self.storyboard instantiateViewControllerWithIdentifier:@"JourneyView"];
    PFObject *item = _tableData[indexPath.row];
    journey.item = item;
    [journey view];
    
    //replace hardcoding with call to PFUser object here
    PFUser *loggedinuser = [PFUser currentUser];
    NSString *user = loggedinuser[@"username"];
    NSLog(@"%@", user);
    //NSString *user = @"lhan";
    NSString *driverusername = item[@"driverusername"];
    
    
    // check if user is the driver
    if ([user isEqualToString:driverusername]) {
        GivingRideCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        journey.navigationItem.title = @"Journey";
        journey.name.text = cell.nameLabel.text;
        journey.date.text = cell.dateLabel.text;
        journey.time.text = cell.timeLabel.text;
        journey.image.image = cell.profilePicture.image;
        journey.give_get.text = @"Giving a ride to";
        [self.navigationController pushViewController:journey animated:YES];
    }
    else {
        GettingRideCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       
        journey.navigationItem.title = @"Journey";
        journey.name.text = cell.nameLabel.text;
        journey.date.text = cell.dateLabel.text;
        journey.time.text = cell.timeLabel.text;
        journey.image.image = cell.profilePicture.image;
        journey.give_get.text = @"Getting a ride from";
        [self.navigationController pushViewController:journey animated:YES];
    }
    
}


// Used to pop off seagues

-(IBAction)unWindFromOfferView:(UIStoryboardSegue *)seage {
    //do nothing, FOR NOWWWWW TAN TAN TAAAAAN
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
