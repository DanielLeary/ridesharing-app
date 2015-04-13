//
//  Signup2ViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Signup2ViewController.h"
#import "UserModel.h"

static const int dobPickerRowHeight = 180;
static const int genderPickerRowHeight = 140;

@implementation Signup2ViewController {
    
    LoginViewModel *viewModel;
    NSArray *infoArray;
    NSArray *genderArray;
    
    NSDateFormatter *dateFormatter;
    BOOL dobPickerIsShown;
    BOOL genderPickerIsShown;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *model = [[UserModel alloc] init];
    viewModel = [[LoginViewModel alloc] initWithModel:model];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    infoArray = @[@"Date of Birth:", @"Gender:", @"Interests:"];
    genderArray = @[@"Female", @"Male", @"Other"];
    
    dobPickerIsShown = NO;
    genderPickerIsShown = NO;
}

/*
- (IBAction)position:(id)sender {
    if (position.text.length > 3) {
        [viewModel changePosition:position.text];
    }
}*/


/* METHODS FOR UI */

- (IBAction)signUpPressed:(UIButton *)sender {
    //need to check info
    
    DashboardViewController *dashboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self.navigationController pushViewController:dashboardVC animated:YES];
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dobPickerIsShown && genderPickerIsShown) {
        return [infoArray count] + 2;
    } else if (dobPickerIsShown || genderPickerIsShown) {
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
    if (dobPickerIsShown && genderPickerIsShown) {
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"dobPickerCell"];
        } else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"genderPickerCell"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"infoCellWithPicker"];
            if (indexPath.row == 2 || indexPath.row == 4) {
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
    } else if (genderPickerIsShown) {
        if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"genderPickerCell"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"infoCellWithPicker"];
            if (indexPath.row == 1) {
                cell.textLabel.text = infoArray[1];
            } else if (indexPath.row == 3) {
                cell.textLabel.text = infoArray[2];
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
    if (dobPickerIsShown && genderPickerIsShown) {
        if (indexPath.row == 0) {
            [self hidePicker:tableView inRow:1];
            dobPickerIsShown = NO;
        } else if (indexPath.row == 2) {
            [self hidePicker:tableView inRow:3];
            genderPickerIsShown = NO;
        } else if (indexPath.row == 4) {
            [self showInterestsVC];
        }
    } else if (dobPickerIsShown) {
        if (indexPath.row == 0) {
            [self hidePicker:tableView inRow:1];
            dobPickerIsShown = NO;
        } else if (indexPath.row ==2) {
            [self showPicker:tableView inRow:3];
            genderPickerIsShown = YES;
        } else if (indexPath.row == 3) {
            [self showInterestsVC];
        }
    } else if (genderPickerIsShown) {
        if (indexPath.row ==0) {
            [self showPicker:tableView inRow:1];
            dobPickerIsShown = YES;
        } else if (indexPath.row == 1) {
            [self hidePicker:tableView inRow:2];
            genderPickerIsShown = NO;
        } else if (indexPath.row == 3) {
            [self showInterestsVC];
        }
    } else {
        if (indexPath.row == 0) {
            [self showPicker:tableView inRow:1];
            dobPickerIsShown = YES;
        } else if (indexPath.row == 1) {
            [self showPicker:tableView inRow:2];
            genderPickerIsShown = YES;
        } else if (indexPath.row == 2) {
            [self showInterestsVC];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    if (dobPickerIsShown && genderPickerIsShown) {
        if (indexPath.row == 1) {
            rowHeight = dobPickerRowHeight;
        } else if (indexPath.row == 3) {
            rowHeight = genderPickerRowHeight;
        }
    } else if (dobPickerIsShown && indexPath.row == 1) {
        rowHeight = dobPickerRowHeight;
    } else if (genderPickerIsShown && indexPath.row == 2) {
        rowHeight = genderPickerRowHeight;
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
