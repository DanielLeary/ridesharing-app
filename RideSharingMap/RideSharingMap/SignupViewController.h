//
//  SignupViewController.h
//  RideSharingMap
//
//  Created by Agata Lach on 19/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "Signup2ViewController.h"
#import "User.h"

#define NO_ERROR 0
#define FIRSTNAME_ERROR 1
#define LASTNAME_ERROR 2
#define USERNAME1_ERROR 3
#define USERNAME2_ERROR 4
#define PASSWORD_ERROR 5


@interface SignupViewController : UIViewController
    
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;

@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

//transfers user to the next signup view
- (IBAction)nextPressed:(UIButton *)sender;

@end
