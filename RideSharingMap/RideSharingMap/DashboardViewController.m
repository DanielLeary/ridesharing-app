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
    // Try creating a journey object and sending it to parse
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
    
    
    //------------
    // Test query
    //------------
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Journeys"];
    [query1 whereKey:@"passengerEmail" equalTo:@"leon@gmail.com"];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Journeys"];
    [query2 whereKey:@"driverEmail" equalTo:@"leon@gmail.com"];    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Returned object count: %d .", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"Id is %@", object.objectId);
            }
            
            PFObject *item = objects[0];
            NSString *driveremail = item[@"driverEmail"];
            NSString *passengeremail = item[@"passengerEmail"];
            
            NSLog(@"Driver Email %@", driveremail);
            NSLog(@"Passenger Email %@", passengeremail);
            
            
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        GivingRideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"givingRideCell"];
        cell.nameLabel.text = @"Christina Hicks";
        return cell;
    } else {
        GettingRideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gettingRideCell"];
        cell.nameLabel.text = @"Kevin Smith";
        return cell;
    }
}

// Used to pop off seagues

-(IBAction)unWindFromOfferView:(UIStoryboardSegue *)seage {
    //do nothing, FOR NOWWWWW TAN TAN TAAAAAN
}


@end
