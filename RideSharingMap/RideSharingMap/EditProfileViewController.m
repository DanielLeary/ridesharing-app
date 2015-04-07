//
//  EditProfileViewController.m
//  RideSharingMap
//
//  Created by Lin Han on 9/3/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "EditProfileViewController.h"

static const int numOfRows = 6;

@implementation EditProfileViewController {
    
    ProfileViewModel *profileViewModel;
    NSIndexPath *dobPickerIndexPath;
    BOOL pictureChanged;
    BOOL nameChanged;
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    UserModel *user = [[UserModel alloc] init];
    profileViewModel = [[ProfileViewModel alloc] initWithProfile:user];
    pictureChanged = NO;
}


/* METHODS FOR UI */

//save new info if changed
- (IBAction)saveBarButtonPressed:(id)sender {
    if (pictureChanged) {
        UIImage *newProfilePicture = self.profileImageView.image;
        [profileViewModel setProfilePicture:newProfilePicture];
        [self.delegate updateProfileImage:self image:newProfilePicture];
    }
    if (nameChanged) {
        NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
        NSString *newFirstName = [[[self.userInfoTableView cellForRowAtIndexPath:indexPath0] textLabel] text];
        NSString *newLastName = [[[self.userInfoTableView cellForRowAtIndexPath:indexPath1] textLabel] text];
        [profileViewModel setFirstName:newFirstName];
        [profileViewModel setLastName:newLastName];
        [self.delegate updateProfileName:self firstName:newFirstName lastName:newLastName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


/* METHODS FOR PROFILE PICTURE */

- (IBAction)changeProfilePicturePressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Change profile picture"
        delegate:self
        cancelButtonTitle:@"Cancel"
        destructiveButtonTitle:nil
        otherButtonTitles:@"Take picture", @"Upload picture", nil];
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) { //take picture
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
    } else if (buttonIndex==1) { //upload picture
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
    //only save image if save pressed
    pictureChanged = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self dobPickerIsShown]) {
        return numOfRows + 1;
    } else {
        return numOfRows;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //create picker cell
    if ([self dobPickerIsShown] && (dobPickerIndexPath.row == indexPath.row)) {
            UITableViewCell *cell = [self createDobPickerCell:[profileViewModel getDob]];
        return cell;
    //create normal info cell
    } else {
        InfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        return infoCell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(InfoCell *)infoCell forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            infoCell.infoLabel.text = @"First name:";
            infoCell.infoField.text = [profileViewModel getFirstName];
            break;
        case 1:
            infoCell.infoLabel.text = @"Last name:";
            infoCell.infoField.text = [profileViewModel getLastName];
            break;
        case 2:
            infoCell.infoLabel.text = @"Email:";
            infoCell.infoField.text = [profileViewModel getEmail];
            break;
        case 3:
            infoCell.infoLabel.text = @"Password:";
            infoCell.infoField.text = [profileViewModel getPassword];
            break;
        case 4:
            infoCell.infoLabel.text = @"Age:";
            infoCell.infoField.text = [profileViewModel getAge];
            break;
        case 5:
            infoCell.infoLabel.text = @"Gender:";
            infoCell.infoField.text = [profileViewModel getGender];
            break;
    }
}

// upon row selection, go to editPlaceVC for selected Place
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=0 && indexPath.row<=4) {
        
    }
    [tableView beginUpdates];
    if ([self dobPickerIsShown] && (dobPickerIndexPath.row -1 == indexPath.row)) {
        [self hideDobPicker];
    } else {
        NSIndexPath *newDobPickerIndexPath = [self calculateIndexPathForNewDobPicker:indexPath];
        if ([self dobPickerIsShown]) {
            [self hideDobPicker];
        }
        [self showDobPicker:newDobPickerIndexPath];
        dobPickerIndexPath = [NSIndexPath indexPathForRow:newDobPickerIndexPath.row +1 inSection:0];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endUpdates];
}


/* HELPER PICKER METHODS */

- (bool) dobPickerIsShown {
    return dobPickerIndexPath != nil;
}
        
- (UITableViewCell *)createDobPickerCell:(NSDate *)date {
    static NSString *dobPickerCell = @"dobPickerCell";
    static int dobPickerTag = 1;
    UITableViewCell *cell = [self.userInfoTableView dequeueReusableCellWithIdentifier:dobPickerCell];
    UIDatePicker *dobPicker = (UIDatePicker *)[cell viewWithTag:dobPickerTag];
    [dobPicker setDate:date animated:NO];
    return cell;
}

- (void) showDobPicker:(NSIndexPath *)indexPath {
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row +1 inSection:0]];
    [self.userInfoTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void) hideDobPicker {
    [self.userInfoTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:dobPickerIndexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    dobPickerIndexPath = nil;
}

- (NSIndexPath *)calculateIndexPathForNewDobPicker:(NSIndexPath *)indexPath {
    NSIndexPath *newIndexPath;
    if (([self dobPickerIsShown]) && (dobPickerIndexPath.row < indexPath.row)) {
        newIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
    } else {
        newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    }
    return newIndexPath;
}


@end
