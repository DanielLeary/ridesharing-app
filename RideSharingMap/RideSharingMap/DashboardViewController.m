//
//  DashboardViewController.m
//  RideSharingMap
//
//  Created by Daniel Leary on 26/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "DashboardViewController.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import "Ride.h"
#import "OfferRideTimeViewController.h"
#import "JourneyView.h"


@implementation DashboardViewController {
    
    NSArray *tableData;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //tableData = [NSMutableArray arrayWithObjects:@"Christina Hicks", @"Kevin Smith", nil];
    
    // Creates footer that hides empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
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
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Journeys"];
    [query1 whereKey:@"passengerusername" equalTo:@"lhan"];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Journeys"];
    [query2 whereKey:@"driverusername" equalTo:@"lhan"];    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"Id is %@", object.objectId);
            }
            tableData = objects;
            // reloads tableview after async call complete
            [self.tableView reloadData];
            
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
    return self->tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //replace hardcoding with call to PFUser object here
    NSString *user = @"lhan";
    
    PFObject *item = tableData[indexPath.row];
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
            NSArray *result = [query findObjects];
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
            NSArray *result = [query findObjects];
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
    [journey view];
    
    //replace hardcoding with call to PFUser object here
    NSString *user = @"lhan";
    PFObject *item = tableData[indexPath.row];
    NSString *driverusername = item[@"driverusername"];
    
    NSArray *startc = item[@"start"];
    double num = [startc[0] doubleValue];
    NSLog(@"lat %f", num);    
    
    
    // check if user is the driver
    if ([user isEqualToString:driverusername]) {
        GivingRideCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        PFObject *item = tableData[indexPath.row];
        
        /*
        CLLocationDegrees lat = [startc[0] doubleValue];
        CLLocationDegrees lon = [startc[1] doubleValue];
        CLLocationCoordinate2D jstart = {lat,lon};
        journey.startCoord = jstart;
        
        NSArray *endc = item[@"end"];
        lat = [endc[0] doubleValue];
        lon = [endc[1] doubleValue];
        CLLocationCoordinate2D jend = {lat,lon};
        journey.endCoord = jend;
         */
        
        journey.navigationItem.title = @"Journey";
        journey.item = item;
        journey.name.text = cell.nameLabel.text;
        journey.date.text = cell.dateLabel.text;
        journey.time.text = cell.timeLabel.text;
        journey.image.image = cell.profilePicture.image;
        journey.give_get.text = @"Giving a ride to";
        [self.navigationController pushViewController:journey animated:YES];
    }
    else {
        GettingRideCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       
        PFObject *item = tableData[indexPath.row];
        journey.navigationItem.title = @"Journey";
        journey.item = item;
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
