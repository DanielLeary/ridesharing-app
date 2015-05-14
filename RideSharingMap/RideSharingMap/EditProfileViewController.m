//
//  EditProfileViewController.m
//  RideSharingMap
//
//  Created by Lin Han on 9/3/15.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "EditProfileViewController.h"
#define f @"female"
#define m @"male"
#define unchecked @"checkbox.png"
#define checked @"checkbox-checked.png"



static const int dobPickerRowHeight     = 180;

@implementation EditProfileViewController {
    
    User *user;
    NSArray *infoArray;
    
    NSDateFormatter *dateFormatter;
    int pickerCellRowHeight;
    
    BOOL dobPickerIsShown;
    //BOOL genderPickerIsShown;
    BOOL pictureChanged;
    BOOL nameChanged;
    
    BOOL fChecked;
    BOOL mChecked;
    
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    user = (User*)[PFUser currentUser];
    
    self.profileImageView.image = [UIImage imageWithData:[user getProfilePicture]];
    
    infoArray = @[@"First Name:", @"Last Name:", @"Username:", @"Password:", @"Date of Birth:"];

    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    pickerCellRowHeight = 180;
    dobPickerIsShown = NO;
    pictureChanged = NO;
    nameChanged = NO;
    if ([user getUsername] != nil) {
        fChecked = [[user getGender]  isEqual: f] ? YES : NO;
        mChecked = [[user getGender]  isEqual: m] ? YES : NO;
    }
    else{
        fChecked = NO;
        mChecked = NO;
    }
    
    if (fChecked && !mChecked) {
        [_fCheckBox setImage:[UIImage imageNamed:checked] forState:UIControlStateNormal];
        [_mCheckBox setImage:[UIImage imageNamed:unchecked] forState:UIControlStateNormal];
    }
    else if (mChecked && !fChecked){
        [_mCheckBox setImage:[UIImage imageNamed:checked] forState:UIControlStateNormal];
        [_fCheckBox setImage:[UIImage imageNamed:unchecked] forState:UIControlStateNormal];
    }
    
    self.userInfoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


/* METHODS FOR UI */

//save new info if changed
- (IBAction)saveBarButtonPressed:(id)sender {
    if (pictureChanged) {
        UIImage *newProfilePicture = self.profileImageView.image;
        [user setProfilePicture:newProfilePicture];
        [self.delegate updateProfileImage:self image:newProfilePicture];
    }
    
    NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    
    InfoCell* firstNameCell = (InfoCell*)[self.userInfoTableView cellForRowAtIndexPath:indexPath0];
    InfoCell* lastNameCell = (InfoCell*)[self.userInfoTableView cellForRowAtIndexPath:indexPath1];
    NSString *newFirstName = firstNameCell.infoField.text;
    NSString *newLastName = lastNameCell.infoField.text;
    if (!([newFirstName isEqualToString:user.getFirstName]||[newFirstName isEqualToString:user.getLastName])) {
        [user setFirstName:newFirstName];
        [user setLastName:newLastName];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.delegate updateProfileName:self firstName:newFirstName lastName:newLastName];
        }];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dobChanged:(UIDatePicker *)sender {
    if (dobPickerIsShown) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        UITableViewCell *cell  = [self.userInfoTableView cellForRowAtIndexPath:indexPath];
        [user setDob:sender.date];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:sender.date];
    }
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dobPickerIsShown ) {
        return [infoArray count] + 1;
    } else {
        return [infoArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 0 && indexPath.row <= 3) {
        InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        return cell;
    } else if (indexPath.row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCellWithPicker"];
        cell.textLabel.text = @"Date of birth:";
        cell.detailTextLabel.text = [dateFormatter stringFromDate:[user getDob]];
        return cell;
    } else {
        UITableViewCell *cell;
        if (dobPickerIsShown ) {
            if (indexPath.row == 5) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"dobPickerCell"];
            }
        } else if (dobPickerIsShown) {
            if (indexPath.row == 5) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"dobPickerCell"];
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(InfoCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=0 && indexPath.row<=3) {
        cell.infoLabel.text = infoArray[indexPath.row];
        switch (indexPath.row) {
            case 0:
                cell.infoField.text = [user getFirstName];
                break;
            case 1:
                cell.infoField.text = [user getLastName];
                break;
            case 2:
                cell.infoField.text = [user getUsername];
                break;
            case 3:
                cell.infoField.text = [user getPassword];
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    
    if (dobPickerIsShown) {
        switch (indexPath.row) {
            case 4:
                [self hidePicker:tableView inRow:5];
                dobPickerIsShown = NO;
                break;
            
        }
    }else {
        switch (indexPath.row) {
            case 4:
                [self showPicker:tableView inRow:5];
                dobPickerIsShown = YES;
                break;
                    }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    if (dobPickerIsShown ) {
        if (indexPath.row == 5) {
            rowHeight = dobPickerRowHeight;
        }    } else if (dobPickerIsShown && indexPath.row == 5) {
        rowHeight = dobPickerRowHeight;
    }
    return rowHeight;
}


/* DELEGATE METHOD FOR PICKERS */

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //[viewModel changeSex:genderArray[row]];
}


/* HELPER METHODS FOR PICKERS */

- (void)showPicker:(UITableView *)tableView inRow:(int)row {
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:row inSection:0]];
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)hidePicker:(UITableView *)tableView inRow:(int)row {
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:row inSection:0]];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
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

- (IBAction)maleCheck:(id)sender {
    if (!mChecked) {
        [_mCheckBox setImage:[UIImage imageNamed:checked] forState:UIControlStateNormal];
        [_fCheckBox setImage:[UIImage imageNamed:unchecked] forState:UIControlStateNormal];
        mChecked = YES;
        fChecked = NO;
        [user setGender:m];
    }
    else {
        [_mCheckBox setImage:[UIImage imageNamed:unchecked] forState:UIControlStateNormal];
        [_fCheckBox setImage:[UIImage imageNamed:checked] forState:UIControlStateNormal];
        mChecked = NO;
        fChecked = YES;
        [user setGender:f];
    }
}

- (IBAction)femaleCheck:(id)sender {
    if (!fChecked) {
        [_fCheckBox setImage:[UIImage imageNamed:checked] forState:UIControlStateNormal];
        [_mCheckBox setImage:[UIImage imageNamed:unchecked] forState:UIControlStateNormal];
        fChecked = YES;
        mChecked = NO;
        
        [user setGender:f];
        //set gender to female
    }
    else{
        [_fCheckBox setImage:[UIImage imageNamed:unchecked] forState:UIControlStateNormal];
        [_mCheckBox setImage:[UIImage imageNamed:checked] forState:UIControlStateNormal];
        fChecked = NO;
        mChecked = YES;
        
        [user setGender:m];
    }
    
}
@end
