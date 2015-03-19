//
//  Signup2ViewController.h
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewModel.h"

@class LoginViewModel;

@interface Signup2ViewController : UIViewController{
    bool is_female;
    bool is_male;
    IBOutlet UIButton *femaleSelected;
    IBOutlet UIButton *maleSelected;
    IBOutlet UITextField *position;
}
@property (strong, nonatomic) LoginViewModel *viewModel;
- (IBAction)position:(id)sender;

- (IBAction)female:(id)sender;
- (IBAction)male:(id)sender;
- (IBAction)changeImage:(id)sender;

@end
