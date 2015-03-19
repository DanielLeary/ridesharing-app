//
//  LoginModel.m
//  RideSharingMap
//
//  Created by Lach, Agata on 04/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel


-(instancetype)initWithModel:(UserModel *) model{
    self = [super init];
    if (!self) {
        return nil;
    }
    _model = model;
 
    return self;
}

//#pragma mark - Public Methods
-(void)inputFirstName:(NSString*) text{
    
    [self.model setFirstname:text];
    [self.model updateUser];
    /*
    PFUser *user = [PFUser currentUser];
    if (text != nil && user) {
        user[@"Name"] = text;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }];
    }*/
}


-(void)inputSurname:(NSString*) text{
    [self.model setLastname:text];
    [self.model updateUser];
    
    /*PFUser *user = [PFUser currentUser];
    if (text != nil && user) {
        user[@"Surname"] = text;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }];
    }*/
}

-(BOOL)log_in:(NSString*) username :(NSString *)password{
    if ([PFUser logInWithUsername:username password:password] != NULL)
        return true;
    else
        return false;
}

-(int)sign_up:(NSString*)username :(NSString*)password : (NSString*)name : (NSString*)surname{
    //TODO deal with different types of errors while signing up
    if (name.length <2 ) {
        return NAME_ERROR;
    }
    if (surname.length<2) {
        return SURNAME_ERROR;
    }
    
    BOOL containsLetter = NSNotFound != [password rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location;
    BOOL containsNumber = NSNotFound != [password rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet].location;
    if (!containsLetter || !containsNumber || password.length < 6) {
        return PASSWORD_ERROR;
    }
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    
    user[@"Surname"] = surname;
    user[@"Name"] = name;
    
    if (![user signUp]){
        return USERNAME_ERROR;
    };
    return NO_ERROR;
}

@end
