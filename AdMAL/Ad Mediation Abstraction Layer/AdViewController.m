//
//  AdViewController.m
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

#import "AdViewController.h"

@implementation AdViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [adMediation resetDisplay];
    [adMediation resumeAdRefresh];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [adMediation pauseAdRefresh];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [adMediation didRotateInterfaceOrientation];
}

-(void)requestAdWithDelegate:(id<AdMediationALDelegate>)del andPosition:(CGPoint)pos andMainViewContainer:(UIView*)viewContainer {
    adMediation = [[AdMediationALManager sharedManager] requestAdWithDelegate:del andParentViewController:self andParentView:self.view andPosition:pos];
    [adMediation retain];
    adMediation.uiMainContainerView = viewContainer;
}

-(void)requestAdWithDelegate:(id<AdMediationALDelegate>)del andPosition:(CGPoint)pos {
    [self requestAdWithDelegate:del andPosition:pos andMainViewContainer:nil];
}

-(void)dealloc {
    [adMediation release];
    
    [super dealloc];
}

@end
