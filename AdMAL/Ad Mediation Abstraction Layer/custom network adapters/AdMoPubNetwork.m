//
//  AdMoPubNetwork.m
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

#import "AdMoPubNetwork.h"
#import "AdGlobals.h"
#import "MPAdConversionTracker.h"

@implementation AdMoPubNetwork

+(BOOL)checkNetworkSettings:(NSDictionary *)networkSettings {
    if(!networkSettings) {
        NSLog(@"Can't enable the MoPub network because you've specified a nil settings dictionary");
        return false;
    }
    
    //Verify the app key
    NSString *appKey = [networkSettings objectForKey:S_APPKEY];
    
    if(!appKey) { //appKey not specified in settings dictionary
        NSLog(@"Can't enable the MoPub network because you've not specified the app key using the S_APPKEY key in settings dictionary");
        return false;
    }
    
    if([[appKey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@""]) { //siteId is empty
        NSLog(@"Can't enable the MoPub network because the siteId you've specified in the settings dictionary using the key S_APPKEY is empty");
        return false;
    }
    
    return true;
}

+(void)startApplication:(NSDictionary *)networkSettings {
    
    [[MPAdConversionTracker sharedConversionTracker] reportApplicationOpenForApplicationID:[networkSettings objectForKey:S_APPKEY]];
    
    NSLog(@"MoPub adapter: started.");
}

-(NSString *)networkName {
    return NETWORK_MOPUB;
}

-(BOOL)requestAdWithDelegate:(id<AdCustomNetworkDelegate>)del andSettings:(NSDictionary *)networkSettings {
    
    if(![super requestAdWithDelegate:del andSettings:networkSettings]) {
        if([delegate respondsToSelector:@selector(customNetworkDidFailReceiveAd)])
            [delegate customNetworkDidFailReceiveAd];
        
        return FALSE;
    }
    
    if(!adView) {
        
        NSString *appKey = [networkSettings objectForKey:S_APPKEY];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            adView = [[MPAdView alloc] initWithAdUnitId:appKey size:MOPUB_LEADERBOARD_SIZE];
        else
            adView = [[MPAdView alloc] initWithAdUnitId:appKey size:MOPUB_BANNER_SIZE];
        adView.delegate = self;
        adView.ignoresAutorefresh = TRUE;
    }
    
    [adView loadAd];  
    
    return TRUE;
}

-(void)unloadAd {
    [super unloadAd];
}

-(void)dealloc {
    [adView setDelegate:nil];
    [adView release];
    
    [super dealloc];
}

#pragma MPAdViewDelegate

-(UIViewController *)viewControllerForPresentingModalView {
    if([delegate respondsToSelector:@selector(customNetworkViewController)])
        return [delegate customNetworkViewController];
    else
        return nil;
}

-(void)adViewDidLoadAd:(MPAdView *)view {
    NSLog(@"MoPub adapter: received ad");
    
    view.frame = CGRectMake(0, 0, view.adContentViewSize.width, view.adContentViewSize.height);
    
    if([delegate respondsToSelector:@selector(customNetworkDidReceiveAd:)])
        [delegate customNetworkDidReceiveAd:view];
}

-(void)adViewDidFailToLoadAd:(MPAdView *)view {
    NSLog(@"MoPub adapter: failed to receive ad");
    
    if([delegate respondsToSelector:@selector(customNetworkDidFailReceiveAd)])
        [delegate customNetworkDidFailReceiveAd];
}

-(void)willPresentModalViewForAd:(MPAdView *)view {
    if([delegate respondsToSelector:@selector(customNetworkWillPresentModalViewForAd)])
        [delegate customNetworkWillPresentModalViewForAd];
}

-(void)didDismissModalViewForAd:(MPAdView *)view {
    if([delegate respondsToSelector:@selector(customNetworkDidDismissModalViewForAd)])
        [delegate customNetworkDidDismissModalViewForAd];
}

-(void)adViewShouldClose:(MPAdView *)view {
    if([delegate respondsToSelector:@selector(customNetworkShouldCallNextAd)])
        [delegate customNetworkShouldCallNextAd];
}


@end
