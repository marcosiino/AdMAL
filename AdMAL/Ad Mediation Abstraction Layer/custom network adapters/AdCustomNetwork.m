//
//  AdCustomNetwork.m
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

#import "AdCustomNetwork.h"
/*#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>*/

@implementation AdCustomNetwork
@synthesize delegate;

/*
- (BOOL)connected 
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    return !(networkStatus == NotReachable);
}*/

+(BOOL)checkNetworkSettings:(NSDictionary *)networkSettings {
    return TRUE;
}

+(void)startApplication:(NSDictionary *)networkSettings {
    
}


-(BOOL)requestAdWithDelegate:(id<AdCustomNetworkDelegate>)del andSettings:(NSDictionary *)networkSettings {
    delegate = del;
    
   /* if(![self connected])
        return FALSE;*/
    
    return TRUE;
}

-(void)unloadAd {
    delegate = nil;
}

@end
