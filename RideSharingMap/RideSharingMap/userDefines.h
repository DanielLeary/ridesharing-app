//
//  userDefines.h
//  RideSharingMap
//
//  Created by Agata Lach on 13/05/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#ifndef RideSharingMap_userDefines_h
#define RideSharingMap_userDefines_h

#define OBJECTID @"objectId"

// User table column names
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

// Offer table column names
#define OFFER @"Offers"
#define O_STARTPOS @"start"
#define O_ENDLAT @"endLat"
#define O_ENDLONG @"endLong"
#define O_TIME @"dateTimeStart"
#define O_DRIVER @"driver"

// Request table column names
#define REQUEST @"Requests"
#define R_OFFER @"offer"
#define R_DRIVER @"driver"
#define R_PASSENGER @"passenger"
#define R_PICKUPTIME @"passengerPickupTime"
#define R_START @"start"
#define R_END @"end"
#define R_OFFER @"offer"

// Journey table column names
#define JOURNEY @"Journeys"
#define J_DRIVER @"driver"
#define J_PASSENGER @"passenger"
#define J_TIME @"journeyDateTime"
#define J_STARTPOS @"start"
#define J_PICKUP @"pickup"
#define J_END @"end"


// Variance in time and distance for searches
#define TIMEEPSILON 900
#define DISTANCEEPSILON 0.004

//length check for names/passwords
#define MIN_NAME_LEN 2
#define MIN_PASS_LEN 6

//Gender
#define f @"female"
#define m @"male"
#define unchecked @"checked.png"
#define checked @"unchecked.png"

#define blankProfIm @"blank-profile-picture.png"


#endif
