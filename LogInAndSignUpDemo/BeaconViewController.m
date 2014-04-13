//
//  BeaconViewController.m
//  LogInAndSignUpDemo
//
//  Created by Guilherme B. Carvalho on 4/12/14.
//
//

#import "BeaconViewController.h"
#import <Pinterest/Pinterest.h>


#define kMargin             20.0
#define kSampleImageWidth   320.0
#define kSampleImageHeight  200.0

#define kPinItButtonWidth   72.0
#define kPinItButtonHeight  32.0

@interface BeaconViewController (){
    Pinterest*  _pinterest;
}
@end

@implementation BeaconViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Setup PinIt Button
    _pinterest = [[Pinterest alloc] initWithClientId:@"1234" urlSchemeSuffix:@"prod"];

    UIButton* pinItButton = [Pinterest pinItButton];
    [pinItButton setFrame:CGRectMake(20,
                                     10,
                                     kPinItButtonWidth,
                                     kPinItButtonHeight)];
    [pinItButton addTarget:self
                    action:@selector(pinIt:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pinItButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didDismissVC:)]) {
            [self.delegate didDismissVC:self];
        }
    }];
}
- (void)pinIt:(id)sender
{
    [_pinterest createPinWithImageURL:[NSURL URLWithString:@"http://placekitten.com/500/400"]
                            sourceURL:[NSURL URLWithString:@"http://placekitten.com"]
                          description:@"Pinning from Pin It Demo"];
}
@end
