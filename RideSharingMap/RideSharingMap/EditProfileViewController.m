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
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    UserModel *user = [[UserModel alloc] init];
    profileViewModel = [[ProfileViewModel alloc] initWithProfile:user];
}


/* METHODS FOR UI */

- (IBAction)saveBarButtonPressed:(id)sender {
    //save new info
    [self.navigationController popViewControllerAnimated:YES];
}


/* PROFILE PICTURE FUNCTIONS */

- (IBAction)changeProfilePicturePressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Change profile picture"
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
    [profileViewModel setProfilePicture:chosenImage];
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
    static NSString *infoCell = @"infoCell";
    UITableViewCell *cell;
    
    //create picker cell
    if ([self dobPickerIsShown] && (dobPickerIndexPath.row == indexPath.row)) {
        cell = [self createDobPickerCell:[profileViewModel getDob]];
    
        //create normal info cell
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:infoCell];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"First name:";
                cell.detailTextLabel.text = [profileViewModel firstNameText];
                break;
            case 1:
                cell.textLabel.text = @"Last name:";
                cell.detailTextLabel.text = [profileViewModel lastNameText];
                break;
            case 2:
                cell.textLabel.text = @"Email:";
                cell.detailTextLabel.text = [profileViewModel emailText];
                break;
            case 3:
                cell.textLabel.text = @"Password:";
                break;
            case 4:
                cell.textLabel.text = @"Age:";
                cell.detailTextLabel.text = [profileViewModel getAge];
                break;
            case 5:
                cell.textLabel.text = @"Gender:";
                cell.detailTextLabel.text = [profileViewModel getGender];
                break;
        }
    }
    return cell;
}

// upon row selection, go to editPlaceVC for selected Place
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
