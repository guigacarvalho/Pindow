//
//  BeaconViewController.h
//  LogInAndSignUpDemo
//
//  Created by Guilherme B. Carvalho on 4/12/14.
//
//

#import <UIKit/UIKit.h>

@interface BeaconViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *testLabel;
- (IBAction)dismiss:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *beaconInfo;
@end
