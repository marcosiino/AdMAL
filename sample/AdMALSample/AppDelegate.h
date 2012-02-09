//
//  AppDelegate.h
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

#import <UIKit/UIKit.h>

//AdMAL AdWhirl Settings
#define ADWHIRL_APPKEY @"5428334fb70b47419d1ae938e828406d" //put your AdWhirl app key here

//AdMAL Custom Networks
#define MOBCLIX_APPKEY @"" //put your MobClix's app key here
#define BMOBILE_PARTNERID @"" //put your B!Mobile's partner id here
#define BMOBILE_SITEID @""  //put your B!Mobile's site id here
#define MOPUB_APPKEY @"" //put your MoPub's app key here
#define MOBFOX_APPKEY @""  //put your MobFox's app key here
#define APPCIRCLE_APPKEY @""  //put your Flurry AppCircle's app key here

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
