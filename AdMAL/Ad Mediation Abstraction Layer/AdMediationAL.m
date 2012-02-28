//
//  AdMediationAL.m
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

#import "AdMediationAL.h"
#import "AdMediationALManager.h"

@implementation AdMediationAL
@synthesize uiMainContainerView;

#pragma mark instance methods

- (void) hideAds {
    if (adView) {

        //Replace adView's view with "nil"
        [adView replaceBannerViewWith:nil];
        
        //Tell AdWhirl to stop requesting Ads
        [adView ignoreNewAdRequests];
        
        //Set adView delegate to "nil"
        [adView setDelegate:nil];
    
        //Hide adWhirlView
        adView.hidden = YES;
        
        //Resize the view
        if(uiMainContainerView)
            [self autoResizeViewContainer:uiMainContainerView];
    }
}

-(id)init {
    NSAssert(false, @"use initAdWithKey: instead of init");
    
    return nil;
}

-(id)initAdWithDelegate:(id)del andParentViewController:(UIViewController*)viewController andParentView:(UIView*)view andPosition:(CGPoint)pos andAutoresizeContainerView:(UIView *)mainContainerView {
    
    self = [super init];
    
    if(self) {
        NSAssert(viewController != nil, @"parent view controller must not be nil");
        
        delegate = del;
        parentViewController = viewController;
        if(parentView)
            parentView = view;
        else
            parentView = parentViewController.view;
        
        //[parentView retain];
        //[parentViewController retain];
        
        NSAssert(parentView != nil, @"parentView cannot be nil");
        
        adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
        [adView retain];
        
        adView.hidden = YES;
        [parentView addSubview:adView];
        
        adPosition = pos;
        if(adPosition.y == ALIGN_RANDOM) //random y pos (TOP / BOTTOM)?
            //When yRandomPositioning is TRUE, the adPosition.y is set randomly to ALIGN_TOP or ALIGN_BOTTOM in the onReceiveAd method each time an ad is received.
            yRandomPositioning = TRUE;
        else
            yRandomPositioning = FALSE;
        
        self.uiMainContainerView = mainContainerView;
        
        //Position the adView outside the view (on the upside if adPosition.y == ALIGN_TOP or on the bottomside if adPosition.y == ALIGN_BOTTOM) so that when a banner is received and repositionAd is called the view will animate in a way that it seems to popup from the up or bottom side of the view
      /*  if(adPosition.y == ALIGN_TOP)
            adView.frame = CGRectMake(0, -100, parentView.bounds.size.width, 100);
        else if(adPosition.y == ALIGN_BOTTOM)
            adView.frame = CGRectMake(0, parentView.bounds.size.height, parentView.bounds.size.width, 100);
        
        NSLog(@"init %f,%f - %f,%f", adView.frame.origin.x, adView.frame.origin.y, adView.frame.size.width, adView.frame.size.height);
      */  
        customAdViews = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAds) name:@"hideAllAds" object:nil];
        
    }
    
    return self;
}

-(id)initAdWithDelegate:(id)del andParentViewController:(UIViewController*)viewController andParentView:(UIView*)view andPosition:(CGPoint)pos {
    return [self initAdWithDelegate:del andParentViewController:viewController andParentView:view andPosition:pos andAutoresizeContainerView:nil];
}

-(void)deallocateLastCustomNetwork {
    if(lastCustomNetwork != nil) {
        id customNetwork = [customAdViews objectForKey:lastCustomNetwork];
        [customNetwork unloadAd];
        [customAdViews removeObjectForKey:lastCustomNetwork];
        
        NSLog(@"deallocated custom network: %@", lastCustomNetwork);
        
        lastCustomNetwork = nil;
    }
}

-(void)deallocateAllLoadedCustomNetworks {
    for(NSString *key in [customAdViews allKeys]) {
        id customNetwork = [customAdViews objectForKey:key];
        [customNetwork unloadAd];
        
        NSLog(@"deallocated custom network: %@", [customNetwork networkName]);
    }
    
    [customAdViews removeAllObjects];
}

-(void)dealloc {
    //parentView = nil;
    //parentViewController = nil;
    //uiMainContainerView = nil;
    
    adView.delegate = nil;
    [adView release];
    //adView = nil;
    
    [self deallocateAllLoadedCustomNetworks];
    [customAdViews release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

-(id)delegate {
    return delegate;
}

-(void)setDelegate:(id)del {
    delegate = del;
}

-(CGSize)getAdSize {
    return adView.frame.size;
}

-(CGPoint)getAdPosition {
    return adPosition;
}

-(void)repositionAd {
    CGRect frame = adView.frame;
    
    CGSize adSize;
    
    if(lastCustomNetwork == nil) //is not using a custom network
        adSize = adView.actualAdSize; //i use actualAdSize only if it's not currently showing a custom network banner, because in this case actualAdSize will not reflect the custom network banner size
    else
        adSize = adView.frame.size;
    
    //X position
    if(adPosition.x == ALIGN_CENTER)
        frame.origin.x = parentView.bounds.size.width / 2 - adSize.width / 2;
    else if(adPosition.x == ALIGN_LEFT)
        frame.origin.x = 0;
    else if(adPosition.x == ALIGN_RIGHT)
        frame.origin.x = parentView.bounds.size.width - adSize.width;
    else
        frame.origin.x = adPosition.x;
    
    //Y position
    if(adPosition.y == ALIGN_TOP) {
        //Starting y (before animation):
        CGRect startinPos = adView.frame;
        startinPos.origin.y = -adSize.height;
        adView.frame = startinPos;
        
        //final y (after animation)
        frame.origin.y = 0;
    }
    else if(adPosition.y == ALIGN_BOTTOM) {
        
        //Starting y (before animation):
        CGRect startinPos = adView.frame;
        startinPos.origin.y = parentView.bounds.size.height;
        adView.frame = startinPos;
        
        //final y (after animation)
        frame.origin.y = parentView.bounds.size.height - adSize.height;
    }
    else
        frame.origin.y = adPosition.y;
    
    frame.size.width = adSize.width;
    frame.size.height = adSize.height;
    
    [UIView beginAnimations:@"" context:nil];
    adView.frame = frame;
    [UIView commitAnimations];
    
    //[adView setNeedsDisplay];
    //[adView setNeedsLayout];

}

-(void)didRotateInterfaceOrientation {
    [adView rotateToOrientation: [UIApplication sharedApplication].statusBarOrientation];
    [self repositionAd];
    
    if(uiMainContainerView)
        [self autoResizeViewContainer:uiMainContainerView];
}

-(void)autoResizeViewContainer:(UIView *)viewContainer {
    
    if(adView.hidden == NO) { //resize to fit space to the ad
        if(adPosition.y == ALIGN_TOP) {
            [UIView beginAnimations:@"" context:nil];
            viewContainer.frame = CGRectMake(viewContainer.frame.origin.x, adView.frame.size.height, viewContainer.frame.size.width, parentView.bounds.size.height - adView.frame.size.height);
            [UIView commitAnimations];
        }
        else if(adPosition.y == ALIGN_BOTTOM) {
            [UIView beginAnimations:@"" context:nil];
            viewContainer.frame = CGRectMake(viewContainer.frame.origin.x, 0, viewContainer.frame.size.width, parentView.bounds.size.height - adView.frame.size.height);
            [UIView commitAnimations];
        }
    }
    else { //resize back to because no ad is currently showed
        if(adPosition.y == ALIGN_TOP) {
            [UIView beginAnimations:@"" context:nil];
            viewContainer.frame = CGRectMake(viewContainer.frame.origin.x, 0, viewContainer.frame.size.width, parentView.bounds.size.height);
            [UIView commitAnimations];
        }
        else if(adPosition.y == ALIGN_BOTTOM) {
            [UIView beginAnimations:@"" context:nil];
            viewContainer.frame = CGRectMake(viewContainer.frame.origin.x, 0, viewContainer.frame.size.width, parentView.bounds.size.height);
            [UIView commitAnimations];
        }
    }
}

-(void)resetDisplay {
    [self didRotateInterfaceOrientation]; //simulate the rotation of the interface to reset the size of the ad in case the interface has been rotated when the viewcontroller was hidden.
    
    if(uiMainContainerView)
        [self autoResizeViewContainer:uiMainContainerView];
}

-(void)pauseAdRefresh {
    [adView ignoreNewAdRequests];
}

-(void)resumeAdRefresh {
    [adView doNotIgnoreNewAdRequests];
}

-(id)getNetworkAdView:(NSString*)networkName {
    return [customAdViews objectForKey:networkName];
}

-(void)onReceivedAd {
    adView.hidden = NO;
    
    if(yRandomPositioning) { //if y position is set to be random inside the initAdWithDelegate
        
        //Choose a random position between TOP and BOTTOM each time i receive an ad:
        int rnd = arc4random()%2;
        if(rnd == 0)
            adPosition.y = ALIGN_TOP;
        else if(rnd == 1)
            adPosition.y = ALIGN_BOTTOM;
    }
    
    [self repositionAd];
    
    if(uiMainContainerView)
        [self autoResizeViewContainer:uiMainContainerView];
    
    if([delegate respondsToSelector:@selector(adMediationALDidReceiveAdWithRect:)]) {
        [delegate adMediationALDidReceiveAdWithRect:adView.frame];
    }
}

-(void)onFailedReceivingAd {
    
    if(uiMainContainerView)
        [self autoResizeViewContainer:uiMainContainerView];
    
    if([delegate respondsToSelector:@selector(adMediationALDidFailToReceiveAd)]) {
        [delegate adMediationALDidFailToReceiveAd];
    }
    
}

#pragma mark - AdWhirlView delegate

-(NSString *)adWhirlApplicationKey {
    return [[AdMediationALManager sharedManager] appKey];
}

-(UIViewController *)viewControllerForPresentingModalView {
    return parentViewController;
}

-(void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView {
    [self deallocateLastCustomNetwork];
    [self onReceivedAd];
}

-(void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo {
    
    NSLog(@"Did fail to receive ad from AdWhirl supported network adapter: %@", [adWhirlView currAdapter]);
    
    if(yesOrNo == NO) //no more ad to rollback
        adView.hidden = YES; //hide the ad banner
    
    [self onFailedReceivingAd];
}

-(UIDeviceOrientation)adWhirlCurrentOrientation {
    if([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)
        return UIDeviceOrientationPortraitUpsideDown;
    else if([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft)
        return UIDeviceOrientationLandscapeLeft;
    else if([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)
        return UIDeviceOrientationLandscapeRight;
    else
        return UIDeviceOrientationPortrait;
}

#pragma mark Custom Networks (Custom Events Triggers called by AdWhirl)

-(void)requestCustomNetworkAd:(NSString*)network {
    
    //Test if the custom network sdk and custom adapter are available
    if(![AdCustomNetworkFactory getCustomNetworkClass:network]) {
        NSLog(@"Unable to request ad for '%@' custom network: class not found. Have you included the custom network sdk and adapter ?", network);
        
        [adView performSelector:@selector(rollOver) withObject:nil afterDelay:0.1f]; //call rollOver after a while instead of now to avoid a problem that causes an exception (may be due the fact that if i call the rollOver now, and the next networks fail it call the rollOver again and again and this causes a stack of rollOver calls that causes some problems).
        //[adView rollOver];
        return;
    }

    //try to get the instance of the custom network from the loadedCustomNetworks dictionary, if it already exits (has been instanced before)
    id customNetwork = [self getNetworkAdView:network];
    
    NSDictionary *networkSettings = [[AdMediationALManager sharedManager] getSettingsForCustomNetwork:network];
    if(!networkSettings) {
        NSLog(@"AdWhirl requested an ad for '%@' custom network but this network is not enabled in the app. Skipping", network);
        [adView performSelector:@selector(rollOver) withObject:nil afterDelay:0.1f]; //call rollOver after a while instead of now to avoid a problem that causes an exception (may be due the fact that if i call the rollOver now, and the next networks fail it call the rollOver again and again and this causes a stack of rollOver calls that causes some problems)
        //[adView rollOver];
        return;
    }
    
    if(![lastCustomNetwork isEqualToString:network]) //if the last custom network is not the same as this i deallocate it
        [self deallocateLastCustomNetwork];

    //if the loadedCustomNetworks don't have an instance for this custom network i create the instance and save it on the loadedCustomNetworks dictionary
    if(!customNetwork) {
        customNetwork = [AdCustomNetworkFactory createCustomNetwork:network];
        if(customNetwork)
            [customAdViews setObject:customNetwork forKey:network];
    }
    
    //if the customNetwork is valid (it is a subclass of AdCustomNetwork) i call the requestAdWithDelegate:andSettings: method to request an Ad
    if(customNetwork && [customNetwork isKindOfClass:[AdCustomNetwork class]]) {
        
        lastCustomNetwork = network;
        
        [customNetwork requestAdWithDelegate:self andSettings:networkSettings];
    }
}

-(void)mobclix {
    [self requestCustomNetworkAd:NETWORK_MOBCLIX];
}

-(void)bmobile {
    [self requestCustomNetworkAd:NETWORK_BMOBILE];
}

-(void)mopub {
    [self requestCustomNetworkAd:NETWORK_MOPUB];
}

-(void)mobfox {
    [self requestCustomNetworkAd:NETWORK_MOBFOX];
}

-(void)appcircle {
    [self requestCustomNetworkAd:NETWORK_APPCIRCLE];
}

#pragma mark Custom Network Adapter delegate

-(void)customNetworkDidReceiveAd:(UIView *)ad {
    adView.frame = ad.frame;
    [adView replaceBannerViewWith:ad];
    
    [self onReceivedAd];
}

-(void)customNetworkDidFailReceiveAd {
    [self onFailedReceivingAd];
    [adView rollOver];
}

-(UIViewController *)customNetworkViewController {
    return parentViewController;
}

-(void)customNetworkShouldCallNextAd {
    [adView requestFreshAd];
}

-(void)customNetworkWillPresentModalViewForAd {
    [self pauseAdRefresh];
}

-(void)customNetworkDidDismissModalViewForAd {
    [self resumeAdRefresh];
}

@end
