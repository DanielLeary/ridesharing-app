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
        InboxAccepted *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxAccepted"];
        cell.name.text = @"Christina Hicks";
        return cell;
    } else {
        InboxRequest *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxRequest"];
        cell.name.text = @"Kevin Smith";
       
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }
    else {
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
