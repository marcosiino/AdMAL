//
//  AdViewController.h
//  Ad Mediation Abstraction Layer
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
#import "AdMediationAL.h"
#import "AdMediationALManager.h"

//This View Controller simplifies the usage of ad banners with AdMediationAL. Use this as base class for your view controllers.

@interface AdViewController : UIViewController {
    AdMediationAL *adMediation;
}

//Request an ad banner and automatically resizes the viewContainer (a container that contains all the main UI, for example the current tab UI) when a banner appear, and viceversa. The auto resize function only works if pos is POSITION_TOP or POSITION_BOTTOM.
-(void)requestAdWithDelegate:(id<AdMediationALDelegate>)del andPosition:(CGPoint)pos andMainViewContainer:(UIView*)viewContainer;

//Request an ad banner without automatically resizing the viewContainer (see above)
-(void)requestAdWithDelegate:(id<AdMediationALDelegate>)del andPosition:(CGPoint)pos;

//Hide the banner view and stop requesting new ads
-(void)hideAds;

@end
