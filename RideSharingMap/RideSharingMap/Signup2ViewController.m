//
//  Signup2ViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Signup2ViewController.h"
#import "UserModel.h"

static const int numOfRows = 3;

@implementation Signup2ViewController {
    
    LoginViewModel *viewModel;
    NSDateFormatter *dateFormatter;
    int pickerCellRowHeight;
    BOOL dobPickerIsShown;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UserModel *model = [[UserModel alloc] init];
    viewModel = [[LoginViewModel alloc] initWithModel:model];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    pickerCellRowHeight = 180;
    dobPickerIsShown = false;
}
/*
- (IBAction)position:(id)sender {
    if (position.text.length > 3) {
        [viewModel changePosition:position.text];
    }
}

- (IBAction)female:(id)sender {
    if (is_female == 0){
        [femaleSelected setSelected:YES];
        [maleSelected setSelected:NO];
        is_female = 1;
        is_male = 0;
    } else {
        [femaleSelected setSelected:NO];
        [maleSelected setSelected:YES];
        is_female = 0;
        is_male = 1;
    }
    [viewModel changeSex:is_female? @"F":@"M"];
}

- (IBAction)male:(id)sender {
    if (is_male == 0){
        [maleSelected setSelected:YES];
        [femaleSelected setSelected:NO];
        is_male = 1;
        is_female = 0;
    } else {
        [maleSelected setSelected:NO];
        [femaleSelected setSelected:YES];
        is_male = 0;
        is_female = 1;
    }
    [viewModel changeSex:is_female? @"F":@"M"];
}*/


/* METHODS FOR UI */

- (IBAction)signUpPressed:(UIButton *)sender {
    //need to check info
    DashboardViewController *dashboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self.navigationController pushViewController:dashboardVC animated:YES];
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
    if (dobPickerIsShown && indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dobPickerCell"];
        return cell;
        //create normal info cell
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCellWithPicker"];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Date of birth:";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Gender:";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Interests:";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (dobPickerIsShown) {
        if (indexPath.row == 0) {
            //hide picker
            NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0]];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            dobPickerIsShown = NO;
        }
    } else {
        if (indexPath.row == 0) {
            //show dob picker
            NSArray *indexPaths = @[[NSIndexPath indexPathForRow:1 inSection:0]];
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
            dobPickerIsShown = YES;
        } else if (indexPath.row == 1) {
            
        } else if (indexPath.row == 2) {
            //show Interests VC
            InterestsViewController *interestsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InterestsViewController"];
            [self.navigationController pushViewController:interestsVC animated:YES];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    if (dobPickerIsShown && indexPath.row == 1) {
        rowHeight = pickerCellRowHeight;
    }
    return rowHeight;
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
