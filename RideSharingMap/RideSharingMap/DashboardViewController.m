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
    
    testJourney.driverEmail = @"leon@gmail.com";
    
    testJourney.passengerEmail = @"danielleary@hotmail.co.uk";
    
    testJourney.journeyDateTime = [NSDate date];
    
    [testJourney uploadToCloud];
    */
    
}


- (void)viewDidAppear:(BOOL)animated {
    //---------------------------------------------------------------------
    // Get journeys that user is involved in as either driver or passenger
    //---------------------------------------------------------------------
    
    //note: replace hardcoding of "leon@gmail.com" with current user email
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Journeys"];
    [query1 whereKey:@"passengerEmail" equalTo:@"leon@gmail.com"];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Journeys"];
    [query2 whereKey:@"driverEmail" equalTo:@"leon@gmail.com"];    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
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
    NSString *userEmail = @"leon@gmail.com";
    
    PFObject *item = tableData[indexPath.row];
    NSString *driveremail = item[@"driverEmail"];
    NSString *passengeremail = item[@"passengerEmail"];
    NSDate *date = item[@"journeyDateTime"];

    // check if user is the driver
    if ([userEmail isEqualToString:driveremail]) {
        GivingRideCell *cell = [tableView
                                dequeueReusableCellWithIdentifier:@"givingRideCell"];
        
        // query user table for name
        if (passengeremail != NULL) {
            PFQuery *query = [PFUser query];
            [query whereKey:@"email" equalTo:passengeremail];
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
        if (driveremail != NULL) {
            PFQuery *query = [PFUser query];
            [query whereKey:@"email" equalTo:driveremail];
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
    
    PFObject *item = tableData[indexPath.row];
    journey.navigationItem.title = @"Journey";
    journey.item = item;
    
    [self.navigationController pushViewController:journey animated:YES];
     
}


// Used to pop off seagues

-(IBAction)unWindFromOfferView:(UIStoryboardSegue *)seage {
    //do nothing, FOR NOWWWWW TAN TAN TAAAAAN
}


@end
