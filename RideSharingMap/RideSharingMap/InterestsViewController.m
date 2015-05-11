//
//  InterestsViewController.m
//  RideSharingMap
//
//  Created by Lin Han on 2/4/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "InterestsViewController.h"

static NSArray *allInterests;

@implementation InterestsViewController {
    
    UserViewModel *viewModel;
    NSMutableArray *checkedInterests;
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    UserModel *user = [[UserModel alloc] init];
    viewModel = [[UserViewModel alloc] initWithModel:user];
    
    if (user) {
        allInterests = [[NSArray alloc] initWithObjects: @"Architecture", @"Art", @"Books & Literature", @"Dance", @"Design", @"Fashion", @"Film", @"Finance", @"Food & Drinks", @"Health & Fitness", @"Music", @"Photography", @"Politics", @"Sports", @"Technology", @"Travel", nil];
        checkedInterests = [viewModel getInterestsArray];
    }
    
    checkedInterests = [[NSMutableArray alloc] initWithCapacity:5];
}


/* METHODS FOR UI */

- (IBAction)savePressed:(UIBarButtonItem *)sender {
    [viewModel updateInterests:checkedInterests];
    NSLog(@"in table");
    NSLog(@"interests: %@", checkedInterests);
    NSLog(@"count: %lu", (unsigned long)[viewModel getInterestsCount]);
    [self.navigationController popViewControllerAnimated:YES];
}


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
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [checkedInterests removeObject:cell.textLabel.text];
    }
}


@end
