//
//  SelectConfirmationViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 14/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "SelectConfirmationViewController.h"

@interface SelectConfirmationViewController ()

@end

@implementation SelectConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *driver = self.ride.drivers[self.ride.rowNumber];
    PFObject* offer = self.ride.rideOffers[self.ride.rowNumber];
    
    NSString *driverName = [NSString stringWithFormat:@"%@ %@", driver[@"Name"], driver[@"Surname"]];
    NSLog(@"%@", driverName);
    NSDate* date = offer[@"dateTimeStart"];
    
    // date formatting stuff
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM"];
    NSString* dateString = [dateFormatter stringFromDate:date];
    
    // time formatting stuff
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:MM"];
    NSString* timeString = [timeFormatter stringFromDate:date];
    
    
    self.driverName.text = driverName;
    self.date.text = dateString;
    self.time.text = timeString;
    
    PFFile *userImageFile = driver[@"ProfilePicture"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.profileImage.image = [UIImage imageWithData:imageData];
        }
    }];

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitRequest:(UIButton *)sender {
}
@end
