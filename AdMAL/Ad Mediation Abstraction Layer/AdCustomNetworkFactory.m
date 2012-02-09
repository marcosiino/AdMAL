//
//  AdCustomNetworkFactory.m
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

#import "AdCustomNetworkFactory.h"

@implementation AdCustomNetworkFactory

+(id)createCustomNetwork:(NSString *)name {
    if([name isEqualToString:NETWORK_MOBCLIX]) {
        Class networkClass = NSClassFromString(@"AdMobClixNetwork");
        if(networkClass)
            return [[[networkClass alloc] init] autorelease];
    }
    else if([name isEqualToString:NETWORK_BMOBILE]) {
        Class networkClass = NSClassFromString(@"AdBMobileNetwork");
        if(networkClass)
            return [[[networkClass alloc] init] autorelease];
    }
    else if([name isEqualToString:NETWORK_MOPUB]) {
        Class networkClass = NSClassFromString(@"AdMoPubNetwork");
        if(networkClass)
            return [[[networkClass alloc] init] autorelease];
    }
    else if([name isEqualToString:NETWORK_MOBFOX]) {
        Class networkClass = NSClassFromString(@"AdMobFoxNetwork");
        if(networkClass)
            return [[[networkClass alloc] init] autorelease];
    }
    else if([name isEqualToString:NETWORK_APPCIRCLE]) {
        Class networkClass = NSClassFromString(@"AdAppCircleNetwork");
        if(networkClass)
            return [[[networkClass alloc] init] autorelease];
    }
    
    return nil;
}

+(Class)getCustomNetworkClass:(NSString*)name {
    if([name isEqualToString:NETWORK_MOBCLIX]) {
        Class networkClass = NSClassFromString(@"AdMobClixNetwork");
        return networkClass;
    }
    else if([name isEqualToString:NETWORK_BMOBILE]) {
        Class networkClass = NSClassFromString(@"AdBMobileNetwork");
        return networkClass;
    }
    else if([name isEqualToString:NETWORK_MOPUB]) {
        Class networkClass = NSClassFromString(@"AdMoPubNetwork");
        return networkClass;
    }
    else if([name isEqualToString:NETWORK_MOBFOX]) {
        Class networkClass = NSClassFromString(@"AdMobFoxNetwork");
        return networkClass;
    }
    else if([name isEqualToString:NETWORK_APPCIRCLE]) {
        Class networkClass = NSClassFromString(@"AdAppCircleNetwork");
        return networkClass;
    }
    
    return nil;
}

@end
