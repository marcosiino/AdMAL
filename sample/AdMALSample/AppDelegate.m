//
//  AppDelegate.m
//  Ad Mediation Abstraction Layer Sample Project
//

/* Copyright 2012 Marco Siino, DooLabs (http://www.marcosiino.it - http://www.doolabs.com)
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "AppDelegate.h"

#import "FirstViewController.h"

#import "SecondViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

-(void)initAdMAL {
    
    //******** AdMAL Initialization *******
    
    //Set the AdWhirl AppKey
    [[AdMediationALManager sharedManager] setAppKey:ADWHIRL_APPKEY];
    
    //AdMAL Custom Networks initializations (in this example i've disabled them. Uncomment the networks you want to use, add their sdks in the project, add the AdMAL's Custom Networks from the AdMAL/custom network adapters, and set your ad networks' app keys in AppDelegate.h #define constants. See README for more detailed info):
    
    //B!Mobile
    /*[[AdMediationALManager sharedManager] enableCustomNetwork:NETWORK_BMOBILE withSettings:
     [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:BMOBILE_PARTNERID, BMOBILE_SITEID, [NSNumber numberWithBool:FALSE], nil] 
                                 forKeys:[NSArray arrayWithObjects:S_GLOBALKEY, S_APPKEY, S_TESTING, nil]
      ]
     ];*/
    
    //MobClix
    //[[AdMediationALManager sharedManager] enableCustomNetwork:NETWORK_MOBCLIX withSettings:[NSDictionary dictionaryWithObject:MOBCLIX_APPKEY forKey:S_APPKEY]];
    
    //MoPub
    //[[AdMediationALManager sharedManager] enableCustomNetwork:NETWORK_MOPUB withSettings:[NSDictionary dictionaryWithObject:MOPUB_APPKEY forKey:S_APPKEY]];
    
    //MobFox
    //[[AdMediationALManager sharedManager] enableCustomNetwork:NETWORK_MOBFOX withSettings:[NSDictionary dictionaryWithObject:MOBFOX_APPKEY forKey:S_APPKEY]];
    
    //AppCircle
    //[[AdMediationALManager sharedManager] enableCustomNetwork:NETWORK_APPCIRCLE withSettings:[NSDictionary dictionaryWithObject:MOBFOX_APPKEY forKey:S_APPKEY]];
    
    //********************
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initAdMAL];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController1, *viewController2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController_iPhone" bundle:nil];
        viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController_iPhone" bundle:nil];
    } else {
        viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController_iPad" bundle:nil];
        viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController_iPad" bundle:nil];
    }
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
