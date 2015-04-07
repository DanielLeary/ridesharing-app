//
//  Signup2ViewController.m
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Signup2ViewController.h"
#import "UserModel.h"

@interface Signup2ViewController ()

@end

@implementation Signup2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserModel *model = [[UserModel alloc] init];
    self.viewModel = [[LoginViewModel alloc] initWithModel:model];
    
    is_female = false;
    is_male = false;
    
    [femaleSelected setSelected:NO];
    [maleSelected setSelected:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)position:(id)sender {
    if (position.text.length > 3) {
        [self.viewModel changePosition:position.text];
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
    [self.viewModel changeSex:is_female? @"F":@"M"];
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
    [self.viewModel changeSex:is_female? @"F":@"M"];
}

- (IBAction)changeImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageView.image = chosenImage;
    [self.viewModel changePicture:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
