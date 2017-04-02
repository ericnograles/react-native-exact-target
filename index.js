
import { NativeModules, Platform } from 'react-native';

const { RNExactTarget } = NativeModules;

export default {
  initializePushManager: config => {
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

    return RNExactTarget.initializePushManager(configWithDefaults);
  },

  resetBadgeCount: () => {
    if (Platform.OS === 'ios') {
      return RNExactTarget.resetBadgeCount();
    }
    return;
  },

  shouldDisplayAlertViewIfPushReceived: enabled => {
    if (Platform.OS === 'ios') {
      return RNExactTarget.shouldDisplayAlertViewIfPushReceived(enabled);
    }
    return;
  }
};
