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
    
    NSArray *tableData; //array of request object IDs
    BOOL emptyTable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tableData = [[NSArray alloc] init];
    emptyTable = YES;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) viewDidAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Requests"];
    [query whereKey:@"offerer" equalTo:user.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            tableData = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    emptyTable = ([tableData count]==0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([tableData count]==0) ? 1 : [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (emptyTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
        cell.textLabel.text = @"no messages (yet)";
        return cell;
    } else {
        NSString *requester, *date, *time;
        NSDate *dateTime;
        PFObject *object = tableData[indexPath.row];
        requester = object[@"requester"];
        dateTime = object[@"dateTimeStart"];
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd/MM/yy";
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"HH:mm";
    
        date = [dateFormatter stringFromDate:dateTime];
        time = [timeFormatter stringFromDate:dateTime];
    
        InboxRequest *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxRequest"];
    
        cell.name.text = requester;
        cell.date.text = date;
        cell.time.text = time;

        // set button tag to row so we can identify which row
        // tapped button
        cell.acceptbutton.tag = indexPath.row;
        cell.declinebutton.tag = indexPath.row;
    
        // dispatch button taps to the below accept/declineTapped methods, with tag set to indexpath row
        [cell.acceptbutton addTarget:self
                        action:@selector(acceptTapped:)
                forControlEvents:UIControlEventTouchUpInside];
        [cell.declinebutton addTarget:self
                        action:@selector(declineTapped:)
                forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (emptyTable) {
        return 40;
    } else {
        return 130;
    }
}

- (void)acceptTapped:(UIButton*)sender {

    if (sender.tag == 1)
    {
        //code for item at indexpath
        NSInteger ident = sender.tag;
        NSLog(@"Accept tapped, row: %li", ident);
        
    }
}

- (void)declineTapped:(UIButton*)sender {
    if (sender.tag == 1)
    {
        //code for item at index path
        NSInteger ident = sender.tag;
        NSLog(@"Decline tapped, row: %li", ident);
        
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
