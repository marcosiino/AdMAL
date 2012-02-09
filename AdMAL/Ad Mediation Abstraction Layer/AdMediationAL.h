//
//  AdMediationAL.h
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

#import <Foundation/Foundation.h>
#import "AdWhirlView.h"
#import "AdCustomNetwork.h"

//x alignment
#define ALIGN_LEFT -10000
#define ALIGN_CENTER -15000
#define ALIGN_RIGHT -20000

//y alignment
#define ALIGN_TOP -10000
#define ALIGN_BOTTOM -20000
#define ALIGN_RANDOM -30000

//ad standard positions
#define POSITION_TOP CGPointMake(ALIGN_CENTER, ALIGN_TOP)
#define POSITION_BOTTOM CGPointMake(ALIGN_CENTER, ALIGN_BOTTOM)
#define POSITION_RANDOM CGPointMake(ALIGN_CENTER, ALIGN_RANDOM)

@protocol AdMediationALDelegate

-(void)adMediationALDidReceiveAdWithRect:(CGRect)adRect;
-(void)adMediationALDidFailToReceiveAd;

@end

@interface AdMediationAL : NSObject<AdWhirlDelegate, AdCustomNetworkDelegate> {
    id delegate;
    AdWhirlView *adView;
    UIViewController *parentViewController;
    UIView *parentView;
    CGPoint adPosition;
    UIView *uiMainContainerView; //the view that contains the current view UI. If set is resized when the ad is shown and resized back when the ad is hide (works only with POSITION_TOP and POSITION_BOTTOM ad positions
    
    NSMutableDictionary *customAdViews; //a dictionary that contains the custom networks adviews. key = name of the network (i.e. "mobclix". Use the #defines that starts with NETWORK_ in AdMediationLayerALManager.h). Each time a new custom event trigger the AdMediationAL tries to load the related network adview and add it to the dictionary (if it is already added it uses this adview instead of allocating a new one).
    
    NSString *lastCustomNetwork;

    bool yRandomPositioning; //if true assign a random Y position between TOP and BOTTOM to the ad banner y (this is internally set to true when the POSITION_RANDOM is passed to initAdWithDelegate:andParentViewController:andParentView:andPosition:...
}

@property (nonatomic, assign) UIView *uiMainContainerView;  

-(id)initAdWithDelegate:(id<AdMediationALDelegate>)delegate andParentViewController:(UIViewController*)viewController andParentView:(UIView*)view andPosition:(CGPoint)pos;

//Use this to also specify a containerView to be resized when an ad is received or when ad disappear (failed to receive)
-(id)initAdWithDelegate:(id<AdMediationALDelegate>)delegate andParentViewController:(UIViewController*)viewController andParentView:(UIView*)view andPosition:(CGPoint)pos andAutoresizeContainerView:(UIView*)mainContainerView;

-(id)delegate;
-(void)setDelegate:(id<AdMediationALDelegate>)del;
-(void)didRotateInterfaceOrientation;

//call this method inside adMediationALDidReceiveAdWithRect to autoresize a UIView* viewContainer (a view that contains all the current interface controls) based on the current ad banner. This works only if you passed POSITION_TOP or POSITION_BOTTOM in the andPosition: paramers of the init method. If you used POSITION_TOP the viewContainer y position will be offset by the height of the current ad banner and the height of the viewContainer will be resized to fill the remaining space of the parentView. If you used POSITION_BOTTOM the viewContainer y position will be set to 0 and it's height will be set to the height of parentView bounds minus the height of the current ad banner.
-(void)autoResizeViewContainer:(UIView*)viewContainer; 

//Adjust the display of the ad (call this on viewDidAppear)
-(void)resetDisplay;

-(void)pauseAdRefresh;

-(void)resumeAdRefresh;

-(CGSize)getAdSize;
-(CGPoint)getAdPosition;

@end
