//
//  EditProfileViewController.m
//  RideSharingMap
//
//  Created by Lin Han on 9/3/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "EditProfileViewController.h"

@implementation EditProfileViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    UserModel *user = [[UserModel alloc] init];
    self.profileViewModel = [[ProfileViewModel alloc] initWithProfile:user];
}

- (IBAction)saveBarButtonPressed:(id)sender {
    //save new info
    [self.navigationController popViewControllerAnimated:YES];
}

/* PROFILE PICTURE FUNCTIONS */

- (IBAction)addImagePressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add new profile picture"
        delegate:self
        cancelButtonTitle:@"Cancel"
        destructiveButtonTitle:nil
        otherButtonTitles:@"Take picture", @"Upload picture", nil];
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = true;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    } else if (buttonIndex==1) { //take picture
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = true;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.profileImageView.image = chosenImage;
    [self.profileViewModel setProfilePicture:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
