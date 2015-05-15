//
//  EditProfileViewController.h
//  RideSharingMap
//
//  Created by Lin Han on 9/3/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "InfoCell.h"
#import "GenderPickerCell.h"
#import "User.h"

@class EditProfileViewController;

@protocol EditProfileViewControllerDelegate <NSObject>

- (void) updateProfileImage:(EditProfileViewController *)vc image:(UIImage *)image;

- (void) updateProfileName:(EditProfileViewController *)vc firstName:(NSString *)firstName lastName:(NSString *)lastName;

@end

@interface EditProfileViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (assign, nonatomic) id <EditProfileViewControllerDelegate> delegate;

// NAV BAR UI

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;

// VIEW UI

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UIButton *addImageButton;

// TABLE UI

@property (strong, nonatomic) IBOutlet UITableView *userInfoTableView;

//male checkbox checked
- (IBAction)maleCheck:(id)sender;

//female checkbox checked
- (IBAction)femaleCheck:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *mCheckBox;


@end
