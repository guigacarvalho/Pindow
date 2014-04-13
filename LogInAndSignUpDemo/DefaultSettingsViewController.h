//
//  DefaultSettingsViewController.h
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/14/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//
#import <FYX/FYXVisitManager.h>
#import <Pinterest/Pinterest.h>


@interface DefaultSettingsViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signout;
@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *beaconImg;
@property (weak, nonatomic) IBOutlet UILabel *beaconTitle;
@property (nonatomic, strong) UIImageView *img;
- (IBAction)logOutButtonTapAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (nonatomic) FYXVisitManager *visitManager;

@end
