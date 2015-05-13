//
//  ProfileViewController.m
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ProfileViewController.h"

static const CLLocationCoordinate2D imperialCoord = {51.498639, -0.179344};

@implementation ProfileViewController {
    
    User *user;
    
}


- (void) viewDidLoad {
    [super viewDidLoad];
    user = (User *)[PFUser currentUser];
    //[User pullPlacesArray];
    self.placesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) viewDidAppear:(BOOL)animated {
    self.firstNameLabel.text = [user getFirstName];
    self.lastNameLabel.text = [user getLastName];
    self.profileImageView.image = [UIImage imageWithData:[user getProfilePicture]];
    self.pointsLabel.text = [user getPointsString];
    self.interestsLabel.text = [[user getInterestsArray] componentsJoinedByString:@", "];
    
    [self.placesTableView reloadData];
    self.placesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


/* METHODS FOR UI RESPONSES */

- (IBAction)logoutBarButtonPressed:(UIBarButtonItem *)sender {
    [User logOut];
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication] delegate];
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginStoryboard"];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    appDelegateTemp.window.rootViewController = loginVC;
}

/*- (IBAction)addNewPlaceButtonPressed:(id)sender {
 //segue to AddPlaceViewController
 AddPlaceViewController *addPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
 addPlaceVC.delegate = self;
 [self.navigationController pushViewController:addPlaceVC animated:YES];
 }*/

- (IBAction)editProfileButtonPressed:(UIBarButtonItem *)sender {
    EditProfileViewController *editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    editProfileVC.delegate = self;
    [self.navigationController pushViewController:editProfileVC animated:YES];
}


/* ADDPLACEVC DELEGATE METHODS */

- (void) addNewPlace:(Place *)place {
    [User addPlace:place];
    [self.placesTableView reloadData];
}

- (void) editPlace:(NSUInteger)indexPath withPlace:(Place *)place {
    [User replacePlaceAtIndex:indexPath withPlace:place];
    [self.placesTableView reloadData];
}


/* EDITPROFILEVC DELEGATE METHODS */

- (void) updateProfileImage:(EditProfileViewController *)vc image:(UIImage *)image {
    //[profileViewModel setProfilePicture:image];
    [self.profileImageView reloadInputViews];
}

- (void) updateProfileName:(EditProfileViewController *)vc firstName:(NSString *)firstName lastName:(NSString *)lastName {
    self.firstNameLabel.text = firstName;
    self.lastNameLabel.text = lastName;
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [User getFavPlacesCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //int test =[User getFavPlacesCount];
    if (indexPath.row < [User getFavPlacesCount]) {
        cell.textLabel.text = [[User getPlaceAtIndex:indexPath.row] name];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
        [cell.textLabel setTextColor:[UIColor grayColor]];
    }
    return cell;
}

// upon row selection, go to editPlaceVC for selected Place
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [User getFavPlacesCount]) {
        // set up editPlaceVC
        AddPlaceViewController *editPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
        //editPlaceVC.delegate = self;
        editPlaceVC.editing = YES;
        editPlaceVC.placeIndexPath = indexPath.row;
        // update editPlaceVC for selected place
        Place *place = [User getPlaceAtIndex:indexPath.row];
        [editPlaceVC view];
        editPlaceVC.placeNameField.text = place.name;
        editPlaceVC.placeLocationField.text = place.zipcode;
        MKCoordinateRegion region;
        if (CLLocationCoordinate2DIsValid(place.coordinates)) {
            region = MKCoordinateRegionMakeWithDistance(place.coordinates, 500, 500);
            [editPlaceVC.mapView setRegion:region animated:YES];
        } else {
            // hardcode location for now
            NSLog(@"hardcoded location");
            region = MKCoordinateRegionMakeWithDistance(imperialCoord, 500, 500);
            [editPlaceVC.mapView setRegion:region animated:YES];
        }
        [self.navigationController pushViewController:editPlaceVC animated:YES];
    } else {
        AddPlaceViewController *addPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
        //addPlaceVC.delegate = self;
        addPlaceVC.editing = NO;
        [self.navigationController pushViewController:addPlaceVC animated:YES];
    }
}


/* METHODS FOR EDITING THE TABLE */

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// function to delete rows from placesTableView
- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete the row from data source
        [User removePlaceAtIndex:[indexPath row]];
        // delete row from table
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
