#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif

#if __has_include(<React/RCTEventEmitter.h>)
#import <React/RCTEventEmitter.h>
#else
#import "RCTEventEmitter.h"
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
