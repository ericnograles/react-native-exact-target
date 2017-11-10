
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

@interface RNExactTarget : RCTEventEmitter <RCTBridgeModule>
- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *_Nonnull)notificationSettings;
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *_Nonnull)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *_Nonnull)error;
- (void)handleRemoteNotification:(NSDictionary *_Nullable)userInfo;
- (void)handleLocalNotification:(UILocalNotification *_Nullable)localNotification;

@end
  
