//
//  ProfileViewController.m
//  RideSharingMap
//
//  Created by Han, Lin on 22/02/2015.
//  Copyright (c) 2015 Vaneet Mehta. All rights reserved.
//

#import "ProfileViewController.h"

static const CLLocationDegrees emptyCoord = -1000;
static const CLLocationCoordinate2D imperialCoord = {51.498639, -0.179344};

@implementation ProfileViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    UserModel *user = [[UserModel alloc] init];
    self.profileViewModel = [[ProfileViewModel alloc] initWithProfile:user];
    
    if (user) {
        self.username_label.text = self.profileViewModel.usernameText;
        self.name_label.text = self.profileViewModel.firstNameText;
        self.surname_label.text = self.profileViewModel.lastNameText;
        self.carField.text = self.profileViewModel.carText;
    }
    
    /*
    // Create currentUser object from locally cached user
    PFUser *currentUser = [PFUser currentUser];
    // If user is currently signed in
    if(currentUser) {
        // Set the name_label to the current users username
        _username_label.text = currentUser.username;
        if(currentUser[@"Car"] != nil){
            _carField.text = currentUser[@"Car"];
            
        }
        if(currentUser[@"Name"] != nil){
            _name_label.text = currentUser[@"Name"];
            
        }
        if(currentUser[@"Surname"] != nil){
            _surname_label.text = currentUser[@"Surname"];
            
        }
    }*/
}

- (void) viewDidAppear:(BOOL)animated {
    NSUInteger count = [self.profileViewModel getFavPlacesCount];
    NSLog(@"IN ARRAY: %lu", (unsigned long)count);
    for (int i=0; i<count; i++) {
        Place *place = [self.profileViewModel getPlaceAtIndex:i];
        NSLog(@"%@, %f, %f", place.getName, place.getLatitude, place.getLongitude);
    }
}


/* TABLE DELEGATE METHODS */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.profileViewModel getFavPlacesCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.profileViewModel getPlaceAtIndex:indexPath.row] getName];
    return cell;
}

// upon row selection, go to editPlaceVC for selected Place
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddPlaceViewController *editPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
    editPlaceVC.delegate = self;
    editPlaceVC.editing = YES;
    editPlaceVC.placeIndexPath = indexPath.row;
    // set up editPlaceVC for selected place
    //[editPlaceVC view];
    Place *place = [self.profileViewModel getPlaceAtIndex:indexPath.row];
    NSLog(@"!!coordinates for place: %@, %f, %f", place.getName, place.getLatitude, place.getLongitude);
    [editPlaceVC view];
    editPlaceVC.placeNameField.text = place.getName;
    editPlaceVC.placeLocationField.text = place.getZipCode;
    MKCoordinateRegion region;
    if (CLLocationCoordinate2DIsValid(place.getCoordinates)) {
        region = MKCoordinateRegionMakeWithDistance(place.getCoordinates, 500, 500);
        [editPlaceVC.mapView setRegion:region animated:YES];
    } else {
        // hardcode location for now
        NSLog(@"hardcoded location");
        region = MKCoordinateRegionMakeWithDistance(imperialCoord, 500, 500);
        [editPlaceVC.mapView setRegion:region animated:YES];
    }
    [self.navigationController pushViewController:editPlaceVC animated:YES];
}


/* METHODS FOR UI RESPONSES */

//segue to AddPlaceViewController
- (IBAction)addNewPlaceButtonPressed:(id)sender {
    AddPlaceViewController *addPlaceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlaceViewController"];
    addPlaceVC.delegate = self;
    [self.navigationController pushViewController:addPlaceVC animated:YES];
}


/* ADDPLACEVC DELEGATE METHODS */

- (void) addNewPlace:(AddPlaceViewController *)vc place:(Place *)place {
    [self.profileViewModel addPlace:place];
    [self.placesTableView reloadData];
}

- (void) editPlace:(AddPlaceViewController *)vc atIndex:(NSUInteger)indexPath withPlace:(Place *)place {
    [self.profileViewModel replacePlaceAtIndex:indexPath withPlace:place];
    [self.placesTableView reloadData];
}


/* METHODS FOR EDITING THE TABLE */

- (IBAction)editButtonPressed:(id)sender {
    if ([_editPlacesButton.currentTitle isEqualToString:@"Edit"]) {
        [self setEditing:YES animated:YES];
    } else if ([_editPlacesButton.currentTitle isEqualToString:@"Done"]) {
        [self setEditing:NO animated: YES];
    }
}

// function to initiate editing mode in placesTableView
-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.placesTableView setEditing:editing animated:animated];
    if (editing == YES) {
        [_editPlacesButton setTitle:@"Done" forState:UIControlStateNormal];
    } else {
        [_editPlacesButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

// function to mark editing style as delete
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// function to delete rows from placesTableView
- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete the row from data source
        [self.profileViewModel removePlaceAtIndex:[indexPath row]];
        // delete row from table
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// function to drag move rows in placesTableView
- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath {
    Place *mover = [self.profileViewModel getPlaceAtIndex:[fromIndexPath row]];
    [self.profileViewModel removePlaceAtIndex:[fromIndexPath row]];
    [self.profileViewModel insertPlace:mover atIndex:[toIndexPath row]];
}



- (IBAction)inputCar:(id)sender {
    NSLog(@"edited Car");
    PFUser *currentUser = [PFUser currentUser];
    // If user is currently signed in
    if(currentUser) {
        NSLog(_carField.text);
        NSLog(currentUser.username);
        currentUser[@"Car"] = _carField.text;
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }];
    }

}
@end
