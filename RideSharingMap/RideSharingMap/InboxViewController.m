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
    NSMutableArray *requestsTableData; //array of request PFObjects
    NSMutableArray *requesterTableData; //array of PFUsers for each request
    BOOL emptyTable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    user = (User *)[PFUser currentUser];
    requestsTableData = [[NSMutableArray alloc] init];
    requesterTableData = [[NSMutableArray alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidAppear:(BOOL)animated {
    //get all requests for current user
    PFQuery *query = [PFQuery queryWithClassName:REQUEST];
    [query whereKey:R_DRIVER equalTo:user];
    [query includeKey:R_PASSENGER];
    [query includeKey:R_OFFER];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            requestsTableData = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
            
            if (!emptyTable) {
                //pull info of requesters for tableView
                for (PFObject *request in objects) {
                    PFUser *requester = [request objectForKey:R_PASSENGER];
                    [requesterTableData addObject:requester];
                }
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([requestsTableData count]==0) ? 1 : [requestsTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([requesterTableData count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
        cell.textLabel.text = @"No messages (yet)";
        return cell;
        
    } else {
        InboxRequest *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxRequest"];
        
        PFObject *requestObject = requestsTableData[indexPath.row];
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
        NSDate *dateTime = requestObject[R_PICKUPTIME];
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
    if ([requesterTableData count] == 0) {
        return 50;
    } else {
        return 110;
    }
}


/* METHODS FOR BUTTONS IN CELL */

- (void)acceptTapped:(UIButton *)sender {
    PFUser *driver, *passenger;
    NSDate *dateTime;
    NSArray *start, *pickup, *end;
    
    //get objectId for request of selected cell
    PFObject *requestObject = requestsTableData[sender.tag];
    
    //get info from requests table
    driver = [requestObject objectForKey:R_DRIVER];
    passenger = [requestObject objectForKey:R_PASSENGER];
    dateTime = [requestObject objectForKey:R_PICKUPTIME];
    end = [requestObject objectForKey:R_END];
    PFGeoPoint *geo = [requestObject objectForKey:R_START];
    pickup = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:geo.latitude], [NSNumber numberWithDouble:geo.longitude], nil];
    
    //get start location
    PFObject *offerObject = [requestObject objectForKey:R_OFFER];
    start = [offerObject objectForKey:O_STARTPOS];
    
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
            [requestObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) {
                    [requestsTableData removeObjectAtIndex:sender.tag];
                    [requesterTableData removeObjectAtIndex:sender.tag];
                    [self.tableView reloadData];
                }
            }];
            
            NSLog(@"DONE");
        }
    }];
}

- (void)declineTapped:(UIButton *)sender {
    //get objectId for request of selected cell
    PFObject *requestObject = requestsTableData[sender.tag];
    
    //delete from request table
    [requestsTableData removeObjectAtIndex:sender.tag];
    [requesterTableData removeObjectAtIndex:sender.tag];
    [requestObject deleteInBackground];
    [self.tableView reloadData];
}


@end
