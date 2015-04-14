//
//  DashboardViewController.m
//  RideSharingMap
//
//  Created by Daniel Leary on 26/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "DashboardViewController.h"

@implementation DashboardViewController {
    
    NSMutableArray *tableData;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tableData = [NSMutableArray arrayWithObjects:@"Christina Hicks", @"Kevin Smith", nil];
    
    // Creates footer that hides empty cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    
    
    /*
    NSString *cellid;
    NSString *celltype = [_itemTypes objectAtIndex:indexPath.row];
    int name_tag = 10;
    
    if ([celltype isEqualToString:@"getting"]) {
        cellid = @"getting";
        name_tag = 10;
    }
    else {
        cellid = @"giving";
        name_tag = 20;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    
    UILabel *name = (UILabel *)[cell viewWithTag:name_tag];
    [name setText:[_tableData objectAtIndex:[indexPath row]]];
    
    UILabel *action = (UILabel *)[cell viewWithTag:21];
    [action setText:@"Giving a ride to"];
    
    UIButton *btnName = (UIButton *)[cell viewWithTag:25];
    [btnName setTitle:[_itemTypes objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
    
    return cell;
     */
}


@end
