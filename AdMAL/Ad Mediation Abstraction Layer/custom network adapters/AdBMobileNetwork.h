//
//  AdBMobileNetwork.h
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
#import "AdMarvelView.h"
#import "AdMarvelDelegate.h"

//Settings to pass to enableCustomNetwork:
//S_GLOBALKEY => The B!Mobile partnerId
//S_APPKEY => The B!Mobile siteId
//S_TESTING => (optional) [NSNumber numberWithBool:TRUE] to enable testing bool or [NSNumber numberWithBool:FALSE] instead. Default: FALSE.

@interface AdBMobileNetwork : AdCustomNetwork<AdMarvelDelegate> {
    AdMarvelView *adView;
    NSString *partnerId;
    NSString *siteId;
    BOOL testingMode;
}

@property(nonatomic, copy) NSString *partnerId;
@property(nonatomic, copy) NSString *siteId;

@end
