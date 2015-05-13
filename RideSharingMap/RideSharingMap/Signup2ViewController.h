//
//  Signup2ViewController.h
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "AppDelegate.h"
#import "UserViewModel.h"
#import "InfoCell.h"
#import "GenderPickerCell.h"
#import "InterestsViewController.h"
#import "DashboardViewController.h"

@class LoginViewModel;

@interface Signup2ViewController : UIViewController <GenderPickerCellDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic)   IBOutlet UIImageView  *imageView;

@property (strong, nonatomic) IBOutlet UIButton     *addProfilePictureButton;

@property (strong, nonatomic) IBOutlet UITableView  *userInfoTableView;

@property (weak, nonatomic)   IBOutlet UIButton     *signUpbutton;


//move user to the signup scene
- (IBAction)signUpPressed:(UIButton *)sender;

//provides picture choosing scenes
- (IBAction)addProfilePicturePressed:(UIButton *)sender;

@end
