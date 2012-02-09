//
//  AdCustomNetwork.h
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

@protocol AdCustomNetworkDelegate
-(void)customNetworkDidReceiveAd:(UIView*)ad;
-(void)customNetworkDidFailReceiveAd;
-(UIViewController*)customNetworkViewController;
-(void)customNetworkShouldCallNextAd;
-(void)customNetworkWillPresentModalViewForAd;
-(void)customNetworkDidDismissModalViewForAd;
@end
    
@interface AdCustomNetwork : NSObject {
    id delegate;
}

@property(nonatomic, assign) id delegate;

//Verify if the network settings are correct
+(BOOL)checkNetworkSettings:(NSDictionary*)networkSettings;

//Initialize the network and pass the parameters (appkeys, etc..)
+(void)startApplication:(NSDictionary*)networkSettings;

//return the name of the network (uses the NETWORK_* defines declared in AdGlobals.h)
-(NSString*)networkName;

//Request an ad to the network.
-(BOOL)requestAdWithDelegate:(id<AdCustomNetworkDelegate>)del andSettings:(NSDictionary*)networkSettings;

-(void)unloadAd;


@end
