//
//  AdAppCircleNetwork.m
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

#import "AdAppCircleNetwork.h"
#import "AdGlobals.h"
#import "FlurryAppCircle.h"
#import "FlurryAnalytics.h"

@implementation AdAppCircleNetwork

+(BOOL)checkNetworkSettings:(NSDictionary *)networkSettings {
    if(!networkSettings) {
        NSLog(@"Can't enable the AppCircle network because you've specified a nil settings dictionary");
        return false;
    }
    
    //Verify the app key
    NSString *appKey = [networkSettings objectForKey:S_APPKEY];
    
    if(!appKey) { //appKey not specified in settings dictionary
        NSLog(@"Can't enable the AppCircle network because you've not specified the app key using the S_APPKEY key in settings dictionary");
        return false;
    }
    
    if([[appKey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@""]) { //appKey is empty
        NSLog(@"Can't enable the AppCircle network because the siteId you've specified in the settings dictionary using the key S_APPKEY is empty");
        return false;
    }
    
    return true;
}

+(void)startApplication:(NSDictionary *)networkSettings {
    [FlurryAppCircle setAppCircleEnabled:TRUE];
    [FlurryAppCircle setAppCircleDelegate:self];
    [FlurryAnalytics startSession:[networkSettings objectForKey:S_APPKEY]];
    
    NSLog(@"AppCircle adapter: started Flurry Analytics with AppCircle");
}

-(NSString *)networkName {
    return NETWORK_APPCIRCLE;
}

-(BOOL)requestAdWithDelegate:(id<AdCustomNetworkDelegate>)del andSettings:(NSDictionary *)networkSettings {
    
    if(![super requestAdWithDelegate:del andSettings:networkSettings]) {
        if([delegate respondsToSelector:@selector(customNetworkDidFailReceiveAd)])
            [delegate customNetworkDidFailReceiveAd];
        
        return FALSE;
    }

    if(!adView) {
        UIViewController *viewController = nil;
        UIView *view = nil;
        
        //ask the viewController to the delegate
        if([delegate respondsToSelector:@selector(customNetworkViewController)]) {
            viewController = [delegate customNetworkViewController];
            
            if(!viewController) {
                NSLog(@"AppCircle Network Custom Adapter: Can't request an ad: You must return a valid View Controller using the delegate method customNetworkViewController.");
                return FALSE;
            }
        }
        else {
            NSLog(@"AppCircle Network Custom Adapter: Can't request an ad: You must implement the method customNetworkViewController in the delegate and return a valid view controller.");
            return FALSE;
        }
        
        if(viewController)
            view = viewController.view;
        
        if(!view) {
            NSLog(@"AppCircle Network Custom Adapter: Can't request an ad. The view controller the delegate returned has not a valid view.");
            return FALSE;
        }
        
        adView = [FlurryAppCircle getHook:@"DEFAULT_HOOK" xLoc:0 yLoc:0 view:view attachToView:NO orientation:@"portrait" canvasOrientation:@"portrait" autoRefresh:NO canvasAnimated:YES rewardMessage:nil userCookies:nil];
    }
    else 
        [FlurryAppCircle updateHook:adView];
    
    [self dataAvailable];
    
    return TRUE;
}

-(void)unloadAd {
    [super unloadAd];
}

-(void)dealloc {
    //The demo app didn't released adView, so i don't release it too even if it sounds strange.
    [FlurryAppCircle setAppCircleDelegate:nil];
    if(adView)
        [FlurryAppCircle removeHook:adView];
    
    [super dealloc];
}

#pragma mark - Flurry AppCircle delegate

-(void)dataAvailable {
    if(adView) {
        NSLog(@"Flurry AppCircle Adapter: did receive ad");
        
        if([delegate respondsToSelector:@selector(customNetworkDidReceiveAd:)]) {
            [delegate customNetworkDidReceiveAd:adView];
        }
    }
    else {
        [self dataUnavailable];
    }
}

-(void)dataUnavailable {
    NSLog(@"Flurry AppCircle Adapter: did fail to receive ad");
    
    if([delegate respondsToSelector:@selector(customNetworkDidFailReceiveAd)]) {
        [delegate customNetworkDidFailReceiveAd];
    }
}

-(void)takeoverWillDisplay:(NSString *)hook {
    
}

-(void)takeoverWillClose {
    
}


@end
