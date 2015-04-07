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
    
    [self.model setFirstName:text];
    [self.model updateUser];

}


-(void)inputSurname:(NSString*) text{
    [self.model setLastName:text];
    [self.model updateUser];
    
}

-(void)changeSex:(NSString*) text{
    [self.model setGender:text];
    [self.model updateUser];
}

-(void)changePosition:(NSString*) text{
    [self.model setPosition:text];
    [self.model updateUser];
}


-(void)changePicture:(UIImage*) picture{
    [self.model setProfilePicture:picture];
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
