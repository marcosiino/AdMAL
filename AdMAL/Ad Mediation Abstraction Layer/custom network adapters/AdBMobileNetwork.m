//
//  AdBMobileNetwork.m
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

#import "AdBMobileNetwork.h"
#import "AdGlobals.h"

@implementation AdBMobileNetwork
@synthesize partnerId, siteId;

+(BOOL)checkNetworkSettings:(NSDictionary *)networkSettings {
    if(!networkSettings) {
        NSLog(@"Can't enable the B!Mobile network because you've specified a nil settings dictionary");
        return false;
    }
    
    //Verify the siteId
    NSString *siteId = [networkSettings objectForKey:S_APPKEY];
    
    if(!siteId) { //appKey not specified in settings dictionary
        NSLog(@"Can't enable the B!Mobile network because you've not specified the siteId using the S_APPKEY key in settings dictionary");
        return false;
    }
    
    if([[siteId stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@""]) { //siteId is empty
        NSLog(@"Can't enable the B!Mobile network because the siteId you've specified in the settings dictionary using the key S_APPKEY is empty");
        return false;
    }
    
    //Verify the partnerId
    NSString *partnerId = [networkSettings objectForKey:S_GLOBALKEY];
    
    if(!partnerId) { //appKey not specified in settings dictionary
        NSLog(@"Can't enable the B!Mobile network because you've not specified the partnerId using the S_GLOBALKEY key in settings dictionary");
        return false;
    }
    
    if([[partnerId stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@""]) { //partnerId is empty
        NSLog(@"Can't enable the B!Mobile network because the partnerId you've specified in the settings dictionary using the key S_GLOBALKEY is empty");
        return false;
    }
    
    return true;
}

+(void)startApplication:(NSDictionary *)networkSettings {
    
    NSLog(@"B!Mobile adapter: started.");
}

-(NSString *)networkName {
    return NETWORK_BMOBILE;
}

-(BOOL)requestAdWithDelegate:(id<AdCustomNetworkDelegate>)del andSettings:(NSDictionary *)networkSettings {
    
    if(![super requestAdWithDelegate:del andSettings:networkSettings]) {
        if([delegate respondsToSelector:@selector(customNetworkDidFailReceiveAd)])
            [delegate customNetworkDidFailReceiveAd];
        
        return FALSE;
    }
    
    self.partnerId = [networkSettings objectForKey:S_GLOBALKEY];
    self.siteId = [networkSettings objectForKey:S_APPKEY];

    NSNumber *number = [networkSettings objectForKey:S_TESTING];
    if(number && [number boolValue] == TRUE)
        testingMode = TRUE;
    else 
        testingMode = FALSE;
    
    if(!adView) {
        adView = [AdMarvelView createAdMarvelViewWithDelegate:self];
        [adView retain];
    }
    
    [adView getAdWithNotification];
    
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

#pragma mark AdMarvelDelegate

-(NSString *)partnerId {
    return partnerId;
}

-(NSString *)siteId {
    return siteId;
}

-(CGRect)adMarvelViewFrame {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return CGRectMake(0, 0, 768, 60);
    else
        return CGRectMake(0, 0, 320, 50);
}

-(UIViewController *)applicationUIViewController {
    if([delegate respondsToSelector:@selector(customNetworkViewController)])
        return [delegate customNetworkViewController];
    else return nil;
}

-(void)getAdSucceeded {
    NSLog(@"B!Mobile adapter: received ad");
    
    if([delegate respondsToSelector:@selector(customNetworkDidReceiveAd:)])
        [delegate customNetworkDidReceiveAd:adView];
}

-(void)getAdFailed {
    NSLog(@"B!Mobile adapter: failed to receive ad");
    
    if([delegate respondsToSelector:@selector(customNetworkDidFailReceiveAd)])
        [delegate customNetworkDidFailReceiveAd];
}

-(BOOL)testingEnabled {
    return testingMode;
}

-(void)fullScreenWebViewActivated {
    if([delegate respondsToSelector:@selector(customNetworkWillPresentModalViewForAd)])
        [delegate customNetworkWillPresentModalViewForAd];
}


-(void)fullScreenWebViewClosed {
    if([delegate respondsToSelector:@selector(customNetworkDidDismissModalViewForAd)])
        [delegate customNetworkDidDismissModalViewForAd];
}

@end
