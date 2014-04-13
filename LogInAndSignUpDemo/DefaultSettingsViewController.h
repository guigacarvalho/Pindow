//
//  DefaultSettingsViewController.h
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/14/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//
#import <FYX/FYXVisitManager.h>


@interface DefaultSettingsViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

- (IBAction)loadBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *beaconTitle;
@property (weak, nonatomic) IBOutlet UIView *hidingPane;
@property (weak, nonatomic) IBOutlet UIButton *signout;
@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *beaconImg;
@property (nonatomic, strong) UIImageView *img;
- (IBAction)logOutButtonTapAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (nonatomic) FYXVisitManager *visitManager;

@end
