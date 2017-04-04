#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import "RNExactTarget.h"
#import "ETPush.h"

@implementation RNExactTarget

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(initializePushManager, initializePushManager:(NSDictionary *)etPushConfig resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *appId = [RCTConvert NSString:etPushConfig[@"appId"]];
    NSString *accessToken = [RCTConvert NSString:etPushConfig[@"accessToken"]];
    BOOL *withAnalytics = [RCTConvert BOOL:etPushConfig[@"enableAnalytics"]];
    BOOL *andLocationServices = [RCTConvert BOOL:etPushConfig[@"enableLocationServices"]];
    BOOL *andProximityServices = [RCTConvert BOOL:etPushConfig[@"enableProximityServices"]];
    BOOL *andCloudPages = [RCTConvert BOOL:etPushConfig[@"enableCloudPages"]];
    BOOL *withPIAnalytics = [RCTConvert BOOL:etPushConfig[@"enablePIAnalytics"]];
    
    RCTLogInfo(@"Initializing ETPush with app ID %@ and access token %@", appId, accessToken);
    
    BOOL successful = NO;
    NSError *error = nil;
    
    // Debug flags
    #ifdef DEBUG
    [ETPush setETLoggerToRequiredState:YES];
    #endif
    
    successful = [[ETPush pushManager] configureSDKWithAppID:appId
                                              andAccessToken:accessToken
                                               withAnalytics:withAnalytics
                                         andLocationServices:andLocationServices
                                        andProximityServices:andProximityServices
                                               andCloudPages:andCloudPages
                                             withPIAnalytics:withAnalytics
                                                       error:&error];
    
    if (!successful) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // something failed in the configureSDKWithAppID call - show what the error is
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed configureSDKWithAppID!", @"Failed configureSDKWithAppID!")
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                              otherButtonTitles:nil] show];
        });
        NSString *errorMessage = [NSString stringWithFormat: @"Could not initialize JB4A-SDK with appId %@ and accesstoken %@. Please check your configuration.", appId, accessToken];
        reject(@"sdk_init_error", errorMessage, nil);
    } else {
        resolve(@"successful");
    }
}

RCT_EXPORT_METHOD(resetBadgeCount)
{
    RCTLogInfo(@"Resetting badge count");
    [[ETPush pushManager] resetBadgeCount];
}

RCT_EXPORT_METHOD(shouldDisplayAlertViewIfPushReceived:(BOOL *)enabled) {
    RCTLogInfo(@"shouldDisplayAlertViewIfPushedReceived %i", enabled);
    [[ETPush pushManager] shouldDisplayAlertViewIfPushReceived:enabled];
}

@end
