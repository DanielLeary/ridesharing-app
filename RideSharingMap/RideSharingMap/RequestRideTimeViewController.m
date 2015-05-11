//
//  RequestRideTimeViewController.m
//  RideSharingMap
//
//  Created by Vaneet Mehta on 11/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "RequestRideTimeViewController.h"
#import "RequestRideDestinationViewController.h"
#import "Requests.h"

@interface RequestRideTimeViewController ()
@property (strong)Requests* request;
@end

@implementation RequestRideTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    // set minimum date to today
    NSDate * today = [NSDate date];
    self.request = [[Requests alloc] initWithDate:today];
    [self.timeWheel setMinimumDate:today];
    
    // Everytime wheel changes (UIControlEventValueChanged) runs the method printChange
    [self.timeWheel addTarget:self action:@selector(printChange) forControlEvents:UIControlEventValueChanged];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)printChange {
    NSLog(@"time modified");
    [self.request setDateTimeStart:self.timeWheel.date];
    //NSLog(self.timeWheel.date);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RequestRideDestinationSeague"]) {
        RequestRideDestinationViewController *vc2 = (RequestRideDestinationViewController *)segue.destinationViewController;
        vc2.request = self.request;
        NSLog(@"Prepared for Seague");
    }
    
}

@end
