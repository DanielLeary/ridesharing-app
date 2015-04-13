//
//  GenderPicker.m
//  RideSharingMap
//
//  Created by Lin Han on 13/4/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "GenderPickerCell.h"

@implementation GenderPickerCell

/*
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}*/

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case 0:
            return @"Female";
        case 1:
            return @"Male";
        case 2:
            return @"Unindentified";
        default:
            return @"";
    }
}

//set layout of picker
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSArray *genderArray = @[@"Female", @"Male", @"Unindentified"];
    UILabel *label = (id)view;
    if (!label) {
        label = [[UILabel alloc] init];
    }
    label.textColor = [UIColor blackColor];
    [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    label.textAlignment = NSTextAlignmentCenter;
    if (row < 3) {
        label.text = genderArray[row];
    }
    return label;
}

@end
