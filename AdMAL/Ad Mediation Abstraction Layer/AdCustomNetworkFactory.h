//
//  AdCustomNetworkFactory.h
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
#import "AdGlobals.h"

@interface AdCustomNetworkFactory : NSObject {
    
}

//create an instance of an AdCustomNetwork subclass. Specify the network name in the name parameter using the NETWORK_* defines. The returned instance has a retain count of 1 so it must be released

+(id)createCustomNetwork:(NSString*)name;

//get the Class of the specified custom network. Useful to call the class methods of a certain network class. Use the NETWORK_* defines to pass the network name.
+(Class)getCustomNetworkClass:(NSString*)name;
@end