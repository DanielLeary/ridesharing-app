//
//  GenderPickerCell.h
//  RideSharingMap
//
//  Created by Lin Han on 13/4/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GenderPickerCell;

@protocol GenderPickerCellDelegate <NSObject>

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end


@interface GenderPickerCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <GenderPickerCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;

@end
