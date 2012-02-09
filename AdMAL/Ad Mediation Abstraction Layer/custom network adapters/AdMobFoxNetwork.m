//
//  AdMobFoxNetwork.m
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

#import "AdMobFoxNetwork.h"
#import "AdGlobals.h"

@implementation AdMobFoxNetwork
@synthesize appKey;

+(BOOL)checkNetworkSettings:(NSDictionary *)networkSettings {
    if(!networkSettings) {
        NSLog(@"Can't enable the MobFox network because you've specified a nil settings dictionary");
        return false;
    }
    
    //Verify the app key
    NSString *appKey = [networkSettings objectForKey:S_APPKEY];
    
    if(!appKey) { //appKey not specified in settings dictionary
        NSLog(@"Can't enable the MobFox network because you've not specified the app key using the S_APPKEY key in settings dictionary");
        return false;
    }
    
    if([[appKey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@""]) { //siteId is empty
        NSLog(@"Can't enable the MobFox network because the siteId you've specified in the settings dictionary using the key S_APPKEY is empty");
        return false;
    }
    
    return true;
}

+(void)startApplication:(NSDictionary *)networkSettings {
    NSLog(@"MobFox adapter: started.");
}

-(NSString *)networkName {
    return NETWORK_MOBFOX;
}

-(BOOL)requestAdWithDelegate:(id<AdCustomNetworkDelegate>)del andSettings:(NSDictionary *)networkSettings {
    
    if(![super requestAdWithDelegate:del andSettings:networkSettings]) {
        if([delegate respondsToSelector:@selector(customNetworkDidFailReceiveAd)])
            [delegate customNetworkDidFailReceiveAd];
        
        return FALSE;
    }
    
    self.appKey = [networkSettings objectForKey:S_APPKEY];
    
    if(!adView) {
        adView = [[MobFoxBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    }
    else 
        [adView requestAd]; //calling a method of MobFox that is not exposed on the .h because there is no other method to refresh the ad manually
    
    adView.delegate = self;
    
    return TRUE;
}

-(void)unloadAd {
    [super unloadAd];
}

-(void)dealloc {
    //The demo app didn't released adView, so i don't release it too even if it sounds strange.
    adView.delegate = nil;
    adView = nil;
    
    [appKey release];
    
    [super dealloc];
}

#pragma mark - MobFoxDelegate

-(NSString *)publisherIdForMobFoxBannerView:(MobFoxBannerView *)banner {
    return appKey;
}

-(void)mobfoxBannerViewDidLoadMobFoxAd:(MobFoxBannerView *)banner {
     NSLog(@"MobFox adapter: received ad");
    
    if([delegate respondsToSelector:@selector(customNetworkDidReceiveAd:)])
        [delegate customNetworkDidReceiveAd:adView];
}

-(void)mobfoxBannerView:(MobFoxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    NSLog(@"MobFox adapter: failed to receive ad");
    
    if([delegate respondsToSelector:@selector(customNetworkDidFailReceiveAd)])
        [delegate customNetworkDidFailReceiveAd];

}


@end
