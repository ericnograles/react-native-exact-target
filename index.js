
import { NativeModules, Platform } from 'react-native';

const { RNExactTarget } = NativeModules;

let sdkInitialized = false;

export default {
  isSDKInitialized: () => {
    return sdkInitialized;
  },

  initializePushManager: config => {
    return new Promise(
      (resolve, reject) => {
        let configWithDefaults = Object.assign({}, config, {
          appId: config.appId || 'blank-app-id',
          accessToken: config.accessToken || 'blank-access-token',
          gcmSenderId: config.gcmSenderId || 'blank-gcm-sender-id',
          enableAnalytics: config.enableAnalytics || false,
          enableLocationServices: config.enableLocationServices || false,
          enableProximityServices: config.enableProximityServices || false,
          enableCloudPages: config.enableCloudPages || false,
          enablePIAnalytics: config.enablePIAnalytics || false
        });

        RNExactTarget
          .initializePushManager(configWithDefaults)
          .then(() => {
            sdkInitialized = true;
            resolve();
          })
          .catch(error => {
            sdkInitialized = false;
            reject(error);
          });
      }
    );

  },

  resetBadgeCount: () => {
    if (Platform.OS === 'ios' && sdkInitialized) {
      return RNExactTarget.resetBadgeCount();
    }
    return;
  },

  shouldDisplayAlertViewIfPushReceived: enabled => {
    if (Platform.OS === 'ios' && sdkInitialized) {
      return RNExactTarget.shouldDisplayAlertViewIfPushReceived(enabled);
    }
    return;
  }
};
