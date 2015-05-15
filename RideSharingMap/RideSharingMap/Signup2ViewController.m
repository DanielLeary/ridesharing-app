//
//  Signup2ViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Signup2ViewController.h"
#define f @"female"
#define m @"male"
#define unchecked @"checked.png"
#define checked @"unchecked.png"

static const int dobPickerRowHeight = 180;

@implementation Signup2ViewController {
    
    User *user;

    NSArray *infoArray;
    NSArray *genderArray;
    
    NSDateFormatter *dateFormatter;
    BOOL dobPickerIsShown;
    BOOL genderPickerIsShown;
    
    BOOL fChecked;
    BOOL mChecked;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [User object];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    infoArray = @[@"Date of Birth:", @"Interests:"];
    genderArray = @[@"Female", @"Male", @"Other"];
    
    dobPickerIsShown = NO;
    genderPickerIsShown = NO;
    
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

- (IBAction)signUpPressed:(UIButton *)sender {
    //create new user
    user.username = self.username;
    user.password = self.password;
    user[Plastname] = self.lastName;
    user[Pfirstname] = self.firstName;
    user[Ppoints] = [[NSNumber alloc] initWithInt:0];
    if ([user signUp]) {
        AppDelegate *appDelegeteTemp = [[UIApplication sharedApplication] delegate];
        appDelegeteTemp.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    } else {
        self.errorLabel.text = @"There was a problem signing up.";
    }
}

/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dobPickerIsShown) {
        return [infoArray count] + 1;
    } else {
        return [infoArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell.textLabel.text = infoArray[0];
    }
    if (dobPickerIsShown ) {
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"dobPickerCell"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"infoCellWithPicker"];
            if (indexPath.row == 2) {
                cell.textLabel.text = infoArray[indexPath.row / 2];
            }
        }
    } else if (dobPickerIsShown) {
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"dobPickerCell"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"infoCellWithPicker"];
            if (indexPath.row == 2 || indexPath.row == 3) {
                cell.textLabel.text = infoArray[indexPath.row - 1];
            }
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"infoCellWithPicker"];
        cell.textLabel.text = infoArray[indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView beginUpdates];
    if (dobPickerIsShown) {
        if (indexPath.row == 0) {
            [self hidePicker:tableView inRow:1];
            dobPickerIsShown = NO;
        } else if (indexPath.row == 3) {
            [self showInterestsVC];
        }
    } else if (dobPickerIsShown) {
        if (indexPath.row == 0) {
            [self hidePicker:tableView inRow:1];
            dobPickerIsShown = NO;
        } else if (indexPath.row == 2) {
            [self showInterestsVC];
        }
    } else {
        if (indexPath.row == 0) {
            [self showPicker:tableView inRow:1];
            dobPickerIsShown = YES;
        } else if (indexPath.row == 1) {
            [self showInterestsVC];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endUpdates];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    if (dobPickerIsShown) {
        if (indexPath.row == 1) {
            rowHeight = dobPickerRowHeight;
        }
    } else if (dobPickerIsShown && indexPath.row == 1) {
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

- (void)showInterestsVC {
    InterestsViewController *interestsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InterestsViewController"];
    
    interestsVC.user = user;
    interestsVC.fromSingup = YES;
    
    NSLog(@"Prepared for Seague OfferRideEndSeague");
    NSLog(@"user obj %@", user);
    [self.navigationController pushViewController:interestsVC animated:YES];
}


/* METHODS FOR PROFILE PICTURE */

- (IBAction)addProfilePicturePressed:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add profile picture"
        delegate:self
        cancelButtonTitle:@"Cancel"
        destructiveButtonTitle:nil
        otherButtonTitles:@"Take picture", @"Upload picture", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)fCheck:(id)sender {
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

- (IBAction)mCheck:(id)sender {
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


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //take picture
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = true;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    //upload picture
    } else if (buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = true;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [user setProfilePicture:chosenImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/* KEYBOARD FUNCTIONS */

//MAY NOT NEED THIS
//dismiss keyboard on done button
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//dismiss keyboard on touch outside
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
