//
//  userDefines.h
//  RideSharingMap
//
//  Created by Agata Lach on 13/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#ifndef RideSharingMap_userDefines_h
#define RideSharingMap_userDefines_h

/*
#define firstnameString @"Name"
#define surnameString @"Surname"
#define usernameString @"username"
#define passwordString @"password"
#define genderString @"Gender"
#define carString @"Car"
#define positionString @"Position"
#define pictureString @"ProfilePicture"
#define interestArray @"Interests"
#define favPlaces @"FavPlaces"
 */

#define Pfirstname @"Name"
#define Plastname @"Surname"
#define Pcar @"Car"
#define Pposition @"Position"
#define Pusername @"username"
#define Ppassword @"password"
#define Pdob @"dob"
#define Pgender @"Gender"
#define Ppicture @"ProfilePicture"
#define Pinterests @"Interests"
#define Pfavplaces @"FavPlaces"
#define Ppoints @"points"


// Offer Class Collumn names
#define OFFER @"Offers"
#define O_STARTPOS @"start"
#define O_ENDLAT @"endLat"
#define O_ENDLONG @"endLong"
#define O_TIME @"dateTimeStart"
#define O_DRIVER @"driver"


// Request class Collumn names
#define REQUEST @"Requests"
#define R_PICKUPTIME @"passengerPickUpTime"
#define R_START @"start"
#define R_END @"end"


// Variance in time and distance for searches
#define TIMEEPSILON 900
#define DISTANCEEPSILON 0.004

#endif
