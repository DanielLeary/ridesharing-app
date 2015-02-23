//
//  AddPlaceViewController.m
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "AddPlaceViewController.h"

@implementation AddPlaceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.placeNameField.delegate = self;
    self.placeLocationField.delegate = self;
    //[self.placeNameField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.placeNameField becomeFirstResponder];
}

- (IBAction)saveButtonPressed:(id)sender {
    NSString *newPlaceName = self.placeNameField.text;
    NSString *newPlaceLocation = self.placeLocationField.text;
    [self.delegate addNewPlace:self didFinishEnteringPlace:newPlaceName and:newPlaceLocation];
    NSLog(@"%@, %@", newPlaceName, newPlaceLocation);
    [self.navigationController popViewControllerAnimated:YES];
}


/* KEYBOARD FUNCTIONS */

//dismiss keyboard on done button
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField==_placeNameField) {
        [_placeLocationField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}


//dismiss keyboard on touch outside
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


@end
