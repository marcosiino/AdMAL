//
//  AdMediationALManager.m
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

#import "AdMediationALManager.h"
#import "AdMediationAL.h"
#import "AdCustomNetwork.h"

@implementation AdMediationALManager

#pragma mark Singleton Pattern methods

//these Singleton methods are currently not thread-safe

static id sharedInstance = nil;

+(id)sharedManager {
    
    if(!sharedInstance)
        sharedInstance = [[super allocWithZone:NULL] init];
    
    return sharedInstance;
}

+(id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if(!sharedInstance) {
            sharedInstance = [[super allocWithZone:zone] init];
            return sharedInstance;
        }
    }
    
    NSAssert(false, @"Cannot manually allocate a Singleton. Use +sharedManager instead");
    return nil;
}

+(id)new {
    return [self alloc];
}

-(id)copyWithZone:(NSZone *)zone {
    NSLog(@"AdMediationALManager: attempt to -copy on a Singleton class may be a bug");
    
    [self retain];
    return self;
}

-(id)mutableCopyWithZone:(NSZone*)zone {
    
    return [self copyWithZone:zone];
}

#pragma mark instance methods

-(id)init {
    self = [super init];
    if(self) {
        enabledCustomNetworks = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)setAppKey:(NSString*)key {
    [appKey release];
    appKey = [key copy];
}

-(NSString*)appKey {
    return appKey;
}

//Check the settings dictionary for the specified custom network. This is a preliminary formal check
-(BOOL)checkNetworkSettings:(NSDictionary*)settings forNetwork:(NSString*)network {
    
    //Get the custom network class from the factory and if exists (is included in the project) i call the method startApplication of the custom network class:
    
    Class networkClass = [AdCustomNetworkFactory getCustomNetworkClass:network];
    if(networkClass && [networkClass isSubclassOfClass:[AdCustomNetwork class]])
        return [networkClass checkNetworkSettings:settings];
    
    return false;
}

//Call startApplication on the custom network, passing the settings.
-(void)initializeCustomNetwork:(NSString*)network withSettings:(NSDictionary*)settings {
    
    //Get the custom network class from the factory and if exists (is included in the project) i call the method startApplication of the custom network class:
    
    Class networkClass = [AdCustomNetworkFactory getCustomNetworkClass:network];
    if(networkClass && [networkClass isSubclassOfClass:[AdCustomNetwork class]])
        [networkClass startApplication:settings];

}

-(void)enableCustomNetwork:(NSString *)network withSettings:(NSDictionary *)settings {
    
    if(![AdCustomNetworkFactory getCustomNetworkClass:network]) {
        NSLog(@"Can't enable '%@' custom network: class not found. Have you included the custom network SDK and custom adapter?", network );
    }
    
    if([self checkNetworkSettings:settings forNetwork:network]) {
        [enabledCustomNetworks setObject:settings forKey:network];
    
        [self initializeCustomNetwork:network withSettings:settings];
    }
}

-(NSDictionary*)getSettingsForCustomNetwork:(NSString *)network {
    return [enabledCustomNetworks objectForKey:network];
}

-(AdMediationAL*)requestAdWithDelegate:(id<AdMediationALDelegate>)delegate andParentViewController:(UIViewController*)viewController andParentView:(UIView*)view andPosition:(CGPoint)pos {
    
    NSAssert(appKey != nil && ![appKey isEqualToString:@""], @"you must specify a valid App Key using setAppKey: before calling requestAdWithDelegate:");
    
    AdMediationAL *ad = [[[AdMediationAL alloc] initAdWithDelegate:delegate andParentViewController:viewController andParentView:view andPosition:pos] autorelease];
    
    return ad;
    
}

-(void)hideAllAds {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAllAds" object:nil];
}

-(void)dealloc {
    [appKey release];
    [enabledCustomNetworks release];
    
    [super dealloc];
}

@end
