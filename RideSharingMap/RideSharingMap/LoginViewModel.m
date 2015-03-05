//
//  LoginModel.m
//  RideSharingMap
//
//  Created by Lach, Agata on 04/03/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel



//#pragma mark - Public Methods
+(void)inputFirstName:(NSString*) text{
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
    }
}


+(void)inputSurname:(NSString*) text{
    PFUser *user = [PFUser currentUser];
    if (text != nil && user) {
        user[@"Surname"] = text;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }];
    }
}

+(BOOL)log_in:(NSString*) username :(NSString *)password{
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

+(BOOL)sign_up{
    return TRUE;
}

@end
