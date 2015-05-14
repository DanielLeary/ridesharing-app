//
//  SelectConfirmationViewController.m
//  RideSharingMap
//
//  Created by Shah, Priyav on 14/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "SelectConfirmationViewController.h"
#import <AddressBookUI/AddressBookUI.h>


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
    
    [self getPickUpAddressFromCoordinates:self.ride.startCordinate];
    [self getDestAddressFromCoordinates:self.ride.endCordinate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/* METHODS FOR getting Address */
    
- (void) getPickUpAddressFromCoordinates:(CLLocationCoordinate2D)coordinates {
    CLLocation *location = [[CLLocation alloc] initWithLatitude: coordinates.latitude longitude:coordinates.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            NSLog(@"Geocode failed with error: %@", error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            //self.pickupAddress.text = [NSString stringWithFormat:@"%@", placemark.postalCode];
            self.pickupLocation.text = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            NSLog(@"%@", placemark.postalCode);
        }
    }];
}


- (void) getDestAddressFromCoordinates:(CLLocationCoordinate2D)coordinates {
    CLLocation *location = [[CLLocation alloc] initWithLatitude: coordinates.latitude longitude:coordinates.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count==0) {
            NSLog(@"Geocode failed with error: %@", error);
        } else {
            CLPlacemark *placemark = [placemarks firstObject];
            //self.pickupAddress.text = [NSString stringWithFormat:@"%@", placemark.postalCode];
            self.destinationLocation.text = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
            NSLog(@"%@", placemark.postalCode);
        }
    }];
}


- (IBAction)submitRequest:(UIButton *)sender {
}
@end
