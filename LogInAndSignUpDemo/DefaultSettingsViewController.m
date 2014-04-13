//
//  DefaultSettingsViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/14/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "DefaultSettingsViewController.h"
#import "BeaconViewController.h"
#import <FYX/FYXTransmitter.h>
#import <FYX/FYXVisitManager.h>

@interface DefaultSettingsViewController (){
    BOOL    _detailViewInPresent;
    BOOL    _didLogin;
    
    BeaconViewController *_BeaconVC;
}

@end

@implementation DefaultSettingsViewController


#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        self.welcomeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@! Locating offers...", nil), [[PFUser currentUser] username]];
        [self.signout setHidden:NO];
        [self setTitle:@"Pindow"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.beaconImg setHidden:NO];
            [self.beaconTitle setHidden:NO];
        });
    } else {
        self.welcomeLabel.text = NSLocalizedString(@"Not logged in", nil);
    }


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_signout];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFSignUpFieldsSignUpButton;
        logInViewController.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];
        logInViewController.logInView.backgroundColor = [UIColor whiteColor];
        logInViewController.logInView.usernameField.textColor = [UIColor grayColor];
        logInViewController.logInView.passwordField.textColor = [UIColor grayColor];
        logInViewController.navigationController.navigationBarHidden = YES;
        
        [self.signout setHidden:NO];
        [self setTitle:@"Pindow"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.beaconImg setHidden:NO];
            [self.beaconTitle setHidden:NO];
            
        });

        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController]; 
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:^{
            [self.signout setHidden:NO];
            [self setTitle:@"Pindow"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.beaconImg setHidden:NO];
                [self.beaconTitle setHidden:NO];
                
            });

        }];
    }
    
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    BeaconViewController *beaconViewController = [[BeaconViewController alloc] init];

    [self dismissViewControllerAnimated:YES completion:^{
        _didLogin = YES;
        self.visitManager = [FYXVisitManager new];
        self.visitManager.delegate = self;
        NSMutableDictionary *options = [NSMutableDictionary new];
        [options setObject:[NSNumber numberWithInt:1] forKey:FYXVisitOptionDepartureIntervalInSecondsKey];
        [options setObject:[NSNumber numberWithInt:-45] forKey:FYXVisitOptionArrivalRSSIKey];
        [options setObject:[NSNumber numberWithInt:-65] forKey:FYXVisitOptionDepartureRSSIKey];
        [self.visitManager startWithOptions:options];
    }];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton;
    logInViewController.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];
    logInViewController.logInView.backgroundColor = [UIColor whiteColor];
    logInViewController.logInView.usernameField.textColor = [UIColor grayColor];
    logInViewController.logInView.passwordField.textColor = [UIColor grayColor];
    
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
    

}
-(BOOL) prefersStatusBarHidden{
    return YES;
}

- (void)didDismissVC:(id)sender
{
    _detailViewInPresent = NO;
    _BeaconVC = nil;
}

- (void)didArrive:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter is sighted for the first time
    NSLog(@"I arrived at a Gimbal Beacon!!! %@", visit.transmitter.name);

    NSString *beaconURL = visit.transmitter.name;
    __block NSMutableString *price = [[NSMutableString alloc] init];
    __block NSMutableString *title = [[NSMutableString alloc] init];
    __block NSMutableString *desc = [[NSMutableString alloc] init];
    __block NSMutableString *url = [[NSMutableString alloc] init];
//    NSString *title;
//    NSString *desc;
//    NSString *url;

    if (!_BeaconVC) {
        _BeaconVC = [[BeaconViewController alloc]initWithNibName:nil bundle:nil];
        _BeaconVC.delegate = self;
    }
    
    if (_didLogin && !_detailViewInPresent) {
                _detailViewInPresent = YES;
        
        [self presentViewController:_BeaconVC animated:YES completion:^() {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:beaconURL]];
            _BeaconVC.testLabel.image = [UIImage imageWithData:imageData];
        }];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Beacon"];
    [query whereKey:@"beaconId" equalTo:beaconURL];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objectss, NSError *error) {
        if (!error) {
//            NSLog(@"%@",objectss[0][@"price"]);
            [price stringByAppendingString:objectss[0][@"price"]];
            [title stringByAppendingString:objectss[0][@"title"]];
            [url stringByAppendingString:objectss[0][@"descUrl"]];
            [desc stringByAppendingString:objectss[0][@"desc"]];
//            NSLog(@"%@",price);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_BeaconVC.itemPrice setText:objectss[0][@"price"]];
                [_BeaconVC.itemTitle setText:objectss[0][@"title"]];
                [_BeaconVC.itemDesc setText:objectss[0][@"desc"]];
//                [_BeaconVC.itemPrice setText:objectss[0][@"price"]];
            });

            
        }
    }];

    
    

    
}
- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
        // comments now contains the comments for myPost
//        NSLog(@"@%",[comments count]);
//    }];
    // this will be invoked when an authorized transmitter is sighted during an on-going visit
}
- (void)didDepart:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter has not been sighted for some time
    NSLog(@"I left the proximity of a Gimbal Beacon!!!! %@", visit.transmitter.name);
    NSLog(@"I was around the beacon for %f seconds", visit.dwellTime);
}

- (IBAction)loadBtn:(id)sender {
    
}
@end
