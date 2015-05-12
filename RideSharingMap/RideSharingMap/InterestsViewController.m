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
    
    UserViewModel *viewModel;
    NSMutableArray *checkedInterests;
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    checkedInterests = [[NSMutableArray alloc] initWithCapacity:5];
    UserModel *user = [[UserModel alloc] init];
    viewModel = [[UserViewModel alloc] initWithModel:user];
    
    if (user) {
        allInterests = [[NSArray alloc] initWithObjects: @"Architecture", @"Art", @"Books & Literature", @"Dance", @"Design", @"Fashion", @"Film", @"Finance", @"Food & Drinks", @"Health & Fitness", @"Music", @"Photography", @"Politics", @"Sports", @"Technology", @"Travel", nil];
        checkedInterests = [viewModel getInterestsArray];
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
    if ([viewModel hasInterest:cell.textLabel.text]) {
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
        [viewModel updateInterests:checkedInterests];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [checkedInterests removeObject:cell.textLabel.text];
        [viewModel updateInterests:checkedInterests];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}


@end
