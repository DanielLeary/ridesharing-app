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
    NSDateFormatter *dateFormatter;
    int pickerCellRowHeight;
    BOOL dobPickerIsShown;
    BOOL pictureChanged;
    BOOL nameChanged;
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    UserModel *user = [[UserModel alloc] init];
    profileViewModel = [[ProfileViewModel alloc] initWithProfile:user];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    pickerCellRowHeight = 180;
    dobPickerIsShown = NO;
    pictureChanged = NO;
    nameChanged = NO;
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

- (IBAction)dobChanged:(UIDatePicker *)sender {
    if (dobPickerIsShown) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        UITableViewCell *cell = [self.userInfoTableView cellForRowAtIndexPath:indexPath];
        [profileViewModel setDob:sender.date];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:sender.date];
    }
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
    if (dobPickerIsShown) {
        return numOfRows + 1;
    } else {
        return numOfRows;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //create picker cell
    if (dobPickerIsShown && indexPath.row == 5) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dobPickerCell"];
        return cell;
    //create normal info cell
    } else {
        if (indexPath.row == 4) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCellWithPicker"];
            cell.textLabel.text = @"Date of birth:";
            cell.detailTextLabel.text = [dateFormatter stringFromDate:[profileViewModel getDob]];
            return cell;
        } else if (indexPath.row == 5) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCellWithPicker"];
            cell.textLabel.text = @"Gender:";
            cell.detailTextLabel.text = [profileViewModel getGender];
            return cell;
        } else {
            InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(InfoCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            cell.infoLabel.text = @"First name:";
            cell.infoField.text = [profileViewModel getFirstName];
            break;
        case 1:
            cell.infoLabel.text = @"Last name:";
            cell.infoField.text = [profileViewModel getLastName];
            break;
        case 2:
            cell.infoLabel.text = @"Email:";
            cell.infoField.text = [profileViewModel getEmail];
            break;
        case 3:
            cell.infoLabel.text = @"Password:";
            cell.infoField.text = [profileViewModel getPassword];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (dobPickerIsShown) {
        if (indexPath.row == 4) {
            //hide picker
            NSArray *indexPaths = @[[NSIndexPath indexPathForRow:5 inSection:0]];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            dobPickerIsShown = NO;
        }
    } else {
        if (indexPath.row == 4) {
            //show dob picker
            NSArray *indexPaths = @[[NSIndexPath indexPathForRow:5 inSection:0]];
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
            dobPickerIsShown = YES;
        } else if (indexPath.row == 5) {
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    if (dobPickerIsShown && indexPath.row == 5) {
        rowHeight = pickerCellRowHeight;
    }
    return rowHeight;
}

@end
