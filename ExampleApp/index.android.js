/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';
import ExactTarget from 'react-native-exact-target';

export default class ExampleApp extends Component {
  componentDidMount() {
    ExactTarget.initializePushManager({
      appId: 'test-app-id-android',
      accessToken: 'test-access-token-android',
      enableAnalytics: false,
      enableLocationServices: false,
      enableProximityServices: false,
      enableCloudPages: false,
      enablePIAnalytics: false
    });

    // Should be no-ops, iOS only
    ExactTarget.resetBadgeCount();
    ExactTarget.shouldDisplayAlertViewIfPushReceived(true);
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.android.js
        </Text>
        <Text style={styles.instructions}>
          Double tap R on your keyboard to reload,{'\n'}
          Shake or press menu button for dev menu
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('ExampleApp', () => ExampleApp);
