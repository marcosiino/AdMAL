//
//  AdMediationALManager.h
//  Ad Mediation Abstraction Layer

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
#import "AdMediationAL.h"
#import "AdCustomNetworkFactory.h"
#import "AdGlobals.h"

@interface AdMediationALManager : NSObject {
    NSString *appKey; //app key for the main mediation layer used (actually AdWhirl app key)
    NSMutableDictionary *enabledCustomNetworks;
}

+(id)sharedManager;

-(void)setAppKey:(NSString*)key;
-(NSString*)appKey;

//enable a custom network, pass the settings required (i.e. the network app key. See the S_* defines in AdGlobals. for the settings dictionary keys). Use the NETWORK_* defines declared in AdGlobals.h for the network parameter.
-(void)enableCustomNetwork:(NSString*)network withSettings:(NSDictionary*)settings;

//get the settings dictionary for the specified network. Use the NETWORK_* defines declared in AdGlobals.h for the network parameter.
-(NSDictionary*)getSettingsForCustomNetwork:(NSString*)network;

-(AdMediationAL*)requestAdWithDelegate:(id<AdMediationALDelegate>)delegate andParentViewController:(UIViewController*)viewController andParentView:(UIView*)view andPosition:(CGPoint)pos;

//Hide all ads (sends a notification to all AdMediationAL instances to hide their ad banner view and to stop requesting new ads.
-(void)hideAllAds;

@end
