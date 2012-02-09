//
//  AdMobClixNetwork.m
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

#import "AdMobClixNetwork.h"
#import "Mobclix.h"
#import "AdGlobals.h"

@implementation AdMobClixNetwork

+(BOOL)checkNetworkSettings:(NSDictionary *)networkSettings {
    if(!networkSettings) {
        NSLog(@"Can't enable the MobClix network because you've specified a nil settings dictionary");
        return false;
    }
    
    NSString *key = [networkSettings objectForKey:S_APPKEY];
    
    if(!key) { //appKey not specified in settings dictionary
        NSLog(@"Can't enable the MobClix network because you've not specified the app key using the S_APPKEY in settings dictionary");
        return false;
    }
    
    if([[key stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@""]) { //appKey is empty
        NSLog(@"Can't enable the MobClix network because the settings dictionary key S_APPKEY you've specified is empty");
        return false;
    }
    
    return true;
}

+(void)startApplication:(NSDictionary *)networkSettings {
    [Mobclix startWithApplicationId:[networkSettings objectForKey:S_APPKEY]];
    
    NSLog(@"MobClix adapter: started.");
}

-(NSString *)networkName {
    return NETWORK_MOBCLIX;
}

-(BOOL)requestAdWithDelegate:(id<AdCustomNetworkDelegate>)del andSettings:(NSDictionary *)networkSettings {
    
    if(![super requestAdWithDelegate:del andSettings:networkSettings]) {
        if([delegate respondsToSelector:@selector(customNetworkDidFailReceiveAd)])
            [delegate customNetworkDidFailReceiveAd];
        
        return FALSE;
    }
    
    if(!adView) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            adView = [[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            adView = [[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
        }
    }
    
    [adView setDelegate:self];
    [adView setRefreshTime:-1]; //disables the mobclix autorefresh timer
    
    [adView getAd];
    
    return TRUE;
}

-(void)unloadAd {
    [super unloadAd];
    
    [adView cancelAd];
    [adView setDelegate: nil];
    adView = nil;
}

-(void)dealloc {
    [adView cancelAd];
    [adView setDelegate:nil];
    adView = nil;
    
    [super dealloc];
}

#pragma mark MobClixAdViewDelegate

- (void)adViewDidFinishLoad:(MobclixAdView*)ad {
    NSLog(@"MobClix adapter: received ad");
    
    if([delegate respondsToSelector:@selector(customNetworkDidReceiveAd:)])
        [delegate customNetworkDidReceiveAd:ad];
}

- (void)adView:(MobclixAdView*)ad didFailLoadWithError:(NSError*)error {
    NSLog(@"MobClix adapter: failed to receive ad");
    
    if([delegate respondsToSelector:@selector(customNetworkDidFailReceiveAd)])
        [delegate customNetworkDidFailReceiveAd];
}

@end
