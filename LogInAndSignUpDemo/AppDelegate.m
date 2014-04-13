//
//  AppDelegate.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/14/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "AppDelegate.h"
#import "DefaultSettingsViewController.h"
#import <FYX/FYX.h>

@implementation AppDelegate


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FYX setAppId:@"43bfd4eae19cc6fa4c8c5c24405bfd04dc8fc6ed8a3d2ff35758c09d9905c52f" appSecret:@"ee0afe7cab76157b408c3b65971f7e944ed926ac84a1abb1c5497f38d28c4c67" callbackUrl:@"compindowtest://authcode"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // ****************************************************************************
    // Fill in with your Parse and Twitter credentials. Don't forget to add your
    // Facebook id in Info.plist:
    // ****************************************************************************
    [Parse setApplicationId:@"KBePepaUHb2SlVeT7yLyosAwmoAguwvOTV0Uw4xf" clientKey:@"Mr36QhB5vE2aalgkC8fKfHDlr82eMUiXhweaSOgK"];
    [PFFacebookUtils initializeFacebook];
    [PFTwitterUtils initializeWithConsumerKey:@"your_twitter_consumer_key" consumerSecret:@"your_twitter_consumer_secret"];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DefaultSettingsViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [FYX startService:self];
    [self.window makeKeyAndVisible];
    return YES;
}

// Facebook oauth callback
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Handle an interruption during the authorization flow, such as the user clicking the home button.
    [FBSession.activeSession handleDidBecomeActive];
}
- (void)serviceStarted
{
    // this will be invoked if the service has successfully started
    // bluetooth scanning will be started at this point.
    NSLog(@"FYX Service Successfully Started");
}
- (void)startServiceFailed:(NSError *)error
{
    // this will be called if the service has failed to start
    NSLog(@"%@", error);
}
@end
