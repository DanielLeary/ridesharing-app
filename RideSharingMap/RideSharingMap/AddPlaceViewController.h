//
//  AddPlaceViewController.h
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AddPlaceViewController;

@protocol AddPlaceViewControllerDelegate <NSObject>

- (void) addNewPlace:(AddPlaceViewController *)vc didFinishEnteringPlace:(NSString *)placeName and:(NSString *)placeLocation;

@end

@interface AddPlaceViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *placeNameField;

@property (weak, nonatomic) IBOutlet UITextField *placeLocationField;

@property (weak, nonatomic) id <AddPlaceViewControllerDelegate> delegate;

@end
