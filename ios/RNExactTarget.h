
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

#if __has_include("RCTEventEmitter.h")
#import "RCTEventEmitter.h"
#else
#import <React/RCTEventEmitter.h>
#endif

/**
 Please note that this is a singleton object, and you should reference it as [RNExactTarget pushManager].
 */

@interface RNExactTarget : RCTEventEmitter <RCTBridgeModule>
/**
 Returns (or initializes) the shared pushManager instance.
 @return The singleton instance of an RNExactTarget pushManager.
 */
+ (instancetype _Nullable)pushManager;
- (instancetype _Nonnull)init;

- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *_Nonnull)notificationSettings;
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *_Nonnull)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *_Nonnull)error;
- (void)handleRemoteNotification:(NSDictionary *_Nullable)userInfo;
- (void)handleLocalNotification:(UILocalNotification *_Nullable)localNotification;

@end
