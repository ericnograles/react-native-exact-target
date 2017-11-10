#import <React/RCTConvert.h>
#import <React/RCTLog.h>
#import "RNExactTarget.h"
#import "ETPush.h"
#import "ETAnalytics.h"

@implementation RNExactTarget

bool hasListeners;

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"ET:PUSH_NOTIFICATION_RECEIVED", @"ET:LOCAL_NOTIFICATION_RECEIVED"];
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

// Will be called when this module's first listener is added.
-(void)startObserving {
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
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
        NSString *errorMessage = [NSString stringWithFormat: @"Could not initialize JB4A-SDK with appId %@ and accesstoken %@. Please check your configuration.", appId, accessToken];
        reject(@"sdk_init_error", errorMessage, nil);
    } else {
        /** Register for push notifications - enable all notification types, no categories */
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
            
            // Preparing parameters
            UNAuthorizationOptions authOptions = (UNAuthorizationOptionAlert
                                                  + UNAuthorizationOptionBadge
                                                  + UNAuthorizationOptionSound);
            void (^completionHandler)(BOOL, NSError * _Nullable) = ^(BOOL granted, NSError * _Nullable error) {
                NSLog(@"Registered for remote notifications: %d", granted);
            };
            
            // Start registration to APNS to get a device token
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [[ETPush pushManager] registerForRemoteNotificationsWithDelegate:self
                                                                         options:authOptions
                                                                      categories:nil
                                                               completionHandler:completionHandler];
            }
        }
        else {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound |
                                                    UIUserNotificationTypeAlert
                                                                                     categories:nil];
            // Notify the SDK what user notification settings have been selected
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [[ETPush pushManager] registerUserNotificationSettings:settings];
                [[ETPush pushManager] registerForRemoteNotifications];
            }
        }
        
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

// Wrapper for ETPush method for post-registration delegate methods
- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[ETPush pushManager] didRegisterUserNotificationSettings:notificationSettings];
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // register device token to SFMC
    [[ETPush pushManager] registerDeviceToken:deviceToken];
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[ETPush pushManager] applicationDidFailToRegisterForRemoteNotificationsWithError:error];
    [ETAnalytics trackPageView:@"data://applicationDidFailToRegisterForRemoteNotificationsWithError" andTitle:[error localizedDescription] andItem:nil andSearch:nil];
}

// Handlers for received notification
- (void)handleRemoteNotification:(NSDictionary *_Nullable)userInfo {
    if (hasListeners) {
        [self sendEventWithName:@"ET:PUSH_NOTIFICATION_RECEIVED" body:userInfo];
    }
}

- (void)handleLocalNotification:(UILocalNotification *_Nullable)localNotification {
    if (hasListeners) {
        [self sendEventWithName:@"ET:LOCAL_NOTIFICATION_RECEIVED" body:localNotification];
    }
}

@end
