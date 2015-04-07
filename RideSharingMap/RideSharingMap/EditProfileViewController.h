//
//  EditProfileViewController.h
//  RideSharingMap
//
//  Created by Lin Han on 9/3/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewModel.h"

@interface EditProfileViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// nav bar UI

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;


// view UI

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UIButton *addImageButton;

@property (strong, nonatomic) IBOutlet UITableView *userInfoTableView;


@end
