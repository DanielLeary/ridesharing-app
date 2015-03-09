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
    [PFUser logInWithUsernameInBackground:username password:password
        block:^(PFUser *user, NSError *error) {
            if (user) {
                // Do stuff after successful login.
                
            } else {
                // The login failed. Check error to see why.
            }
        }];
    //TODO  set the return value in the login call
    return TRUE;
}

-(BOOL)sign_up:(NSString*) username :(NSString*) password{
    //TODO deal with different types of errors while signing up
    if (self.model.firstname.length <2 || self.model.lastname.length <2) {
        return FALSE;
    }
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    
    user[@"Surname"] = self.model.lastname;
    user[@"Name"] = self.model.firstname;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            //NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
        }
    }];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        return TRUE;
    }
    return FALSE;
}

@end
