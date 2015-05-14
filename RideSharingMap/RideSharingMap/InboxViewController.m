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
    
    User *user;
    NSArray *requestsTableData; //array of request PFObjects
    NSArray *requesterTableData; //array of PFUsers
    BOOL emptyTable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    user = (User *)[PFUser currentUser];
    requestsTableData = [[NSArray alloc] init];
    emptyTable = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidAppear:(BOOL)animated {
    //get all requests for current user
    PFQuery *query = [PFQuery queryWithClassName:@"Requests"];
    [query whereKey:@"offerer" equalTo:user.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            requestsTableData = objects;
            [self.tableView reloadData];
            emptyTable = ([requestsTableData count]==0);
            
            if (!emptyTable) {
                //pull info of requesters for tableView
                for (PFObject *request in requestsTableData) {
                    PFQuery *query = [PFUser query];
                    [query whereKey:@"objectId" equalTo:request[@"requester"]];
                    requesterTableData = [query findObjects];
                }
            }
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
        PFObject *requestObject = requestsTableData[indexPath.row];
        
            InboxRequest *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxRequest"];
            
            PFUser *requesterUser = requesterTableData[indexPath.row];
        
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
            NSDate *dateTime = requestObject[@"dateTimeStart"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"dd/MM/yy";
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            timeFormatter.dateFormat = @"HH:mm";
    
            cell.date.text = [dateFormatter stringFromDate:dateTime];
            cell.time.text = [timeFormatter stringFromDate:dateTime];
            
            // set button tag to row so we can identify which row
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
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (emptyTable) {
        return 40;
    } else {
        return 110;
    }
}


/* METHODS FOR BUTTONS IN CELL */

- (void)acceptTapped:(UIButton *)sender {
    NSString *driver, *passenger;
    NSDate *dateTime;
    NSArray *start, *pickup, *end;
    
    //get objectId for request of selected cell
    PFObject *requestObject = requestsTableData[sender.tag];
    
    NSLog(@"requestObject: %@", requestObject);
    
    //get info from requests table
    driver = [requestObject objectForKey:R_DRIVER];
    passenger = [requestObject objectForKey:R_PASSENGER];
    dateTime = [requestObject objectForKey:R_PICKUPTIME];
    pickup = [requestObject objectForKey:R_START];
    end = [requestObject objectForKey:R_END];
            
    //get start location from offers table
    PFQuery *offerQuery = [PFQuery queryWithClassName:OFFER];
    [offerQuery whereKey:OBJECTID equalTo:[requestObject objectForKey:R_DRIVER]];
    NSArray *offerResults = [offerQuery findObjects];
    PFObject *offerObject = offerResults[0];
    start = [offerObject objectForKey:O_STARTPOS];
            
    NSLog(@"inserting new journey");
    //insert new journey into journeys table
    PFObject *journey = [PFObject objectWithClassName:JOURNEY];
    journey[J_DRIVER] = driver;
    journey[J_PASSENGER] = passenger;
    journey[J_TIME] = dateTime;
    journey[J_STARTPOS] = start;
    journey[J_PICKUP] = pickup;
    journey[J_END] = end;
    [journey saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //delete from request table
            [requestObject deleteInBackground];
            [self.tableView reloadData];
            //delete from offers table if more than 3 passengers?
            NSLog(@"DONE");
        }
    }];
}

- (void)declineTapped:(UIButton *)sender {
    NSLog(@"decline pressed for row: %ld", (long)sender.tag);
    //get objectId for request of selected cell
    PFObject *requestObject = requestsTableData[sender.tag];
    
    //delete from request table
    [requestObject deleteInBackground];
}


@end
