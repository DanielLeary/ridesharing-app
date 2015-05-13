//
//  InboxViewController.m
//  RideSharingMap
//
//  Created by Daniel Leary on 26/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "InboxViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController {
    
    //array of request object IDs
    NSArray *requestsTableData;
    BOOL emptyTable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    requestsTableData = [[NSArray alloc] init];
    emptyTable = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) viewDidAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Requests"];
    [query whereKey:@"offerer" equalTo:user.objectId];
    
    //asynchronous query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            requestsTableData = objects;
            [self.tableView reloadData];
            emptyTable = ([requestsTableData count]==0);
        } else {
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
    return ([requestsTableData count]==0) ? 1 : [requestsTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (emptyTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
        cell.textLabel.text = @"no messages (yet)";
        return cell;
    } else {
        // get info of requester from parse
        PFObject *object = requestsTableData[indexPath.row];
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" equalTo:object[@"requester"]];
        NSArray *result = [query findObjects];
        
        if (result) {
            InboxRequest *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxRequest"];
            
            PFUser *requesterUser = result[0];
        
            // set name
            cell.name.text = [NSString stringWithFormat:@"%@ %@", requesterUser[@"Name"], requesterUser[@"Surname"]];
            
            // set picture
            PFFile *userProfilePicture = requesterUser[@"ProfilePicture"];
            [userProfilePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    cell.pic.image = [UIImage imageWithData:imageData];
                } else {
                    cell.pic.image = [UIImage imageNamed:@"blank-profile-picture.png"];
                }
            }];
    
            // set date and time
            NSDate *dateTime = object[@"dateTimeStart"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"dd/MM/yy";
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            timeFormatter.dateFormat = @"HH:mm";
    
            cell.date.text = [dateFormatter stringFromDate:dateTime];
            cell.time.text = [timeFormatter stringFromDate:dateTime];
            
        // set button tag to row so we can identify which row
        // tapped button
        cell.acceptButton.tag = indexPath.row;
        cell.declineButton.tag = indexPath.row;
    
        // dispatch button taps to the below accept/declineTapped methods, with tag set to indexpath row
        [cell.acceptButton addTarget:self
                        action:@selector(acceptTapped:)
                forControlEvents:UIControlEventTouchUpInside];
        [cell.declineButton addTarget:self
                        action:@selector(declineTapped:)
                forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (emptyTable) {
        return 40;
    } else {
        return 110;
    }
}

- (void) acceptTapped:(UIButton *)sender {
    NSString *driver, *passenger;
    NSDate *dateTime;
    NSArray *start, *pickup, *end;
    
    //get objectId for request of selected cell
    NSString *requestObjectId = requestsTableData[sender.tag];
    
    //query to find info for new journey
    PFQuery *requestQuery = [PFQuery queryWithClassName:@"Requests"];
    PFObject *requestObject = [requestQuery getObjectWithId:requestObjectId];
    
    //get info from requests table
    driver = [requestObject objectForKey:@"offerer"];
    passenger = [requestObject objectForKey:@"requester"];
    dateTime = [requestObject objectForKey:@"dateTimeStart"];
    pickup = [requestObject objectForKey:@"start"];
    end = [requestObject objectForKey:@"end"];
    
    //get start location from offers table
    PFObject *offerObject = [requestObject objectForKey:@"offerObjectId"];
    start = [offerObject objectForKey:@"start"];
    
    //insert new journey into journeys table
    PFObject *journey = [PFObject objectWithClassName:@"Journeys"];
    journey[@"driverusername"] = driver;
    journey[@"passengerusername"] = passenger;
    journey[@"journeyDateTime"] = dateTime;
    journey[@"start"] = start;
    journey[@"pickup"] = pickup;
    journey[@"end"] = end;
    [journey saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //delete from request table
            [requestObject deleteInBackground];
            //delete from offers table if more than 3 passengers?
            [self.tableView reloadData];
        } else {
        }
    }];
}

- (void) declineTapped:(UIButton *)sender {
    //get objectId for request of selected cell
    NSString *requestObjectId = requestsTableData[sender.tag];
    
    //query to find info for new journey
    PFQuery *requestQuery = [PFQuery queryWithClassName:@"Requests"];
    PFObject *requestObject = [requestQuery getObjectWithId:requestObjectId];
    
    //delete from request table
    [requestObject deleteInBackground];
}


@end
