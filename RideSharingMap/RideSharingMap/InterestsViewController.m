//
//  InterestsViewController.m
//  RideSharingMap
//
//  Created by Lin Han on 2/4/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "InterestsViewController.h"

static NSArray *allInterests;
static const int rowHeight = 40;

@implementation InterestsViewController {
    
    User *user;
    NSMutableArray *checkedInterests;
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    user = (User *)[PFUser currentUser];
    checkedInterests = [[NSMutableArray alloc] initWithCapacity:5];
    
    if (user) {
        allInterests = [[NSArray alloc] initWithObjects: @"Architecture", @"Art", @"Books & Literature", @"Dance", @"Design", @"Fashion", @"Film", @"Finance", @"Food & Drinks", @"Health & Fitness", @"Music", @"Photography", @"Politics", @"Sports", @"Technology", @"Travel", nil];
        if ([user getInterestsArray] != nil ){
            checkedInterests = [user getInterestsArray];
        }
    }
    self.interestsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


/* METHODS FOR UI */


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [allInterests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"InterestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    cell.textLabel.text = [allInterests objectAtIndex:indexPath.row];
    // assign checkmarks to cells
    if ([user hasInterest:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [checkedInterests addObject:cell.textLabel.text];
        [user updateInterests:checkedInterests];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [checkedInterests removeObject:cell.textLabel.text];
        [user updateInterests:checkedInterests];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}


@end
