//
//  BeaconViewController.h
//  LogInAndSignUpDemo
//
//  Created by Guilherme B. Carvalho on 4/12/14.
//
//

#import <UIKit/UIKit.h>

@interface BeaconViewController : UIViewController
@property (nonatomic, assign) id delegate;

@property (weak, nonatomic) IBOutlet UIImageView *testLabel;
- (IBAction)dismiss:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *beaconInfo;
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UITextView *itemDesc;
@property (weak, nonatomic) IBOutlet UILabel *itemPrice;


- (void)didDismissVC:(id)sender;

@end
