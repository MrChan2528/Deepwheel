// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "FBSDKInstrumentManager.h"

#import <FBSDKCoreKit_Basics/FBSDKCoreKit_Basics.h>

#import "FBSDKErrorReporting.h"
#import "FBSDKFeatureChecking.h"
#import "FBSDKGraphRequestFactoryProtocol.h"
#import "FBSDKSettingsProtocol.h"

@interface FBSDKInstrumentManager ()

@property (nonatomic, strong) id<FBSDKFeatureChecking> featureChecker;
@property (nonatomic, strong) id<FBSDKSettings> settings;
@property (nonatomic, strong) id<FBSDKCrashObserving> crashObserver;
@property (nonatomic, strong) id<FBSDKErrorReporting> errorReport;
@property (nonatomic, strong) id<FBSDKCrashHandler> crashHandler;

@end

@implementation FBSDKInstrumentManager

- (void)configureWithFeatureChecker:(id<FBSDKFeatureChecking>)featureChecker
                           settings:(id<FBSDKSettings>)settings
                      crashObserver:(id<FBSDKCrashObserving>)crashObserver
                        errorReport:(id<FBSDKErrorReporting>)errorReport
                       crashHandler:(id<FBSDKCrashHandler>)crashHandler
{
  _featureChecker = featureChecker;
  _settings = settings;
  _crashObserver = crashObserver;
  _errorReport = errorReport;
  _crashHandler = crashHandler;
}

+ (instancetype)shared
{
  static dispatch_once_t nonce;
  static id instance;
  dispatch_once(&nonce, ^{
    instance = [self new];
  });
  return instance;
}

- (void)enable
{
  if (![self.settings isAutoLogAppEventsEnabled]) {
    return;
  }

  [self.featureChecker checkFeature:FBSDKFeatureCrashReport completionBlock:^(BOOL enabled) {
    if (enabled) {
      [self.crashHandler addObserver:self.crashObserver];
    }
  }];
  [self.featureChecker checkFeature:FBSDKFeatureErrorReport completionBlock:^(BOOL enabled) {
    if (enabled) {
      [self.errorReport enable];
    }
  }];
}

#if DEBUG && FBTEST

- (void)reset
{
  self.featureChecker = nil;
  self.settings = nil;
  self.crashObserver = nil;
  self.errorReport = nil;
  self.crashHandler = nil;
  self.featureChecker = nil;
}

#endif

@end
