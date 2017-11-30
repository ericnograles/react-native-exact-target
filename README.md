# react-native-exact-target

## Introduction

react-native-exact-target provides bridging functionality to Salesforce Marketing Cloud's Exact Target SDK, aka the [Journey Builder for iOS](http://salesforce-marketingcloud.github.io/JB4A-SDK-iOS/) and [Journey Builder for Android](http://salesforce-marketingcloud.github.io/JB4A-SDK-Android/) without all the fuss of messing with native code!

## Version Compatibility

| **react-native-exact-target** | **React Native** | **JB4ASDK Android** | **JB4ASDK iPhone** |
| --- | --- | --- | --- |
| 0.0.x+ | < 0.40 | 4.7.1 | 4.7.0.x | 
| 0.1.3+ | > 0.40 and <= 0.46 | 4.7.1 | 4.7.0.x |
| 0.2.0+ | >= 0.47 | 4.7.1 | 4.7.0.x |
| 0.3.x | >= 0.47 | 4.7.1 | 4.7.0.x |

**Note**: Please ignore v0.1.0 - v0.1.2. Incorrect semver was followed here and these releases are therefore deprecated.

## Important Note

This project is still in alpha stages and is not fit for production usage yet. Please stay tuned as we work towards our first RC.

If you're in a crunch and would like to use this, please feel free to fork or [contribute](CONTRIBUTING.md).

## Getting started

`$ npm install react-native-exact-target --save`

### Mostly automatic installation

`$ react-native link react-native-exact-target`

#### iOS (Continued)

1. Ensure that your app has been provisioned with access to the APN, [as described by the JB4A-SDK instructions on iOS Provisioning](https://github.com/salesforce-marketingcloud/LearningAppIos#0017)

#### Android (Continued)

1. Open up `android/build.gradle` and modify the `allprojects` section to look like the following:
    ```
    allprojects {
        repositories {
            mavenLocal()
            jcenter()
            maven {
                // All of React Native (JS, Obj-C sources, Android binaries) is installed from npm
                url "$rootDir/../node_modules/react-native/android"
            }
            maven { url "http://salesforce-marketingcloud.github.io/JB4A-SDK-Android/repository" }
        }
    }
    ```

2. Add the following lines to your app's `AndroidManifest.xml`
    ```xml
       <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
       <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    ```
    
### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-exact-target` and add `RNExactTarget.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNExactTarget.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Ensure that your app has been provisioned with access to the APN, [as described by the JB4A-SDK instructions on iOS Provisioning](https://github.com/salesforce-marketingcloud/LearningAppIos#0017)
5. Run your project (`Cmd+R`)

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.exacttarget.etpushsdk.reactnative.RNExactTargetPackage;` to the imports at the top of the file
  - Add `new RNExactTargetPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-exact-target'
  	project(':react-native-exact-target').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-exact-target/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-exact-target')
  	```
4. Open up `android/build.gradle` and modify the `allprojects` section to look like the following:
    ```
    allprojects {
        repositories {
            mavenLocal()
            jcenter()
            maven {
                // All of React Native (JS, Obj-C sources, Android binaries) is installed from npm
                url "$rootDir/../node_modules/react-native/android"
            }
            maven { url "http://salesforce-marketingcloud.github.io/JB4A-SDK-Android/repository" }
        }
    }
    ```

5. Add the following lines to your app's `AndroidManifest.xml`
    ```xml
       <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
       <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    ```

## Important Notes

### Android

* The Android bridge locks the GMS and Play Services versions to 9.2.0, as that is a constraint of the version of the JB4A-SDK we are using (4.7.1)
  * We hopefully can sync up with the SFMC/ExactTarget folks to come up with a more elegant way to handle this, but please take note that this project may conflict with such things as `react-native-maps` or anything requiring GMS on Android

#### Forcing 9.2.4

In order to force your Android to a specific version of Android GMS to support ETPush SDK 4.7.1, please modify your `android/build.gradle`'s `allprojects` to be as follows.

**NOTE**: This might break other 3rd party dependencies, such as `react-native-maps` or `react-native-google-analytics-bridge` that rely on more modern versions of Android GMS.  We are working on making this more generic, please stay tuned.

```
allprojects {
  ...
  configurations.all {
          resolutionStrategy {
              eachDependency { DependencyResolveDetails details ->
                  if (details.requested.group == 'com.google.android.gms') {
                      details.useVersion "9.2.0"
                  }
              }
          }
      }
}
```

## Usage

### Example App

[An example RN app](https://github.com/ericnograles/react-native-exact-target-example-app) has been spun up in a separate repo. Please feel free to clone the repo and run the app to tinker with various settings.

### Registering an App

* Please follow the instructions set forth by the <a href="https://github.com/ericnograles/LearningAppIos/blob/master/README.md#create-your-apps-in-the-app-center" target="_blank">Salesforce Marketing Cloud iOS Learning App</a>.
  * Take note of the resulting App ID and Access Token

### Initializing

Typically, you'll want to initialize ExactTarget on the `componentDidMount` of your App.js, like so:

#### iOS

```jsx
import ExactTarget from 'react-native-exact-target';

componentDidMount() {
        ExactTarget
          .initializePushManager({
            appId: 'test-app-id-ios',
            accessToken: 'test-access-token-ios',
            enableAnalytics: false,
            enableLocationServices: false,
            enableProximityServices: false,
            enableCloudPages: false,
            enablePIAnalytics: false
          })
          .catch(error => {
            console.log('There has been an error');
            console.error(error);
          });
        
        // This is to register the app on APNs, this bit isn't needed for GCM on Android
        ExactTarget.registerForRemoteNotifications();
}
```

#### Android

```jsx
import ExactTarget from 'react-native-exact-target';

componentDidMount() {
        ExactTarget
          .initializePushManager({
            appId: 'test-app-id-ios',
            accessToken: 'test-access-token-ios',
            enableAnalytics: false,
            enableLocationServices: false,
            enableProximityServices: false,
            enableCloudPages: false,
            enablePIAnalytics: false
          })
          .catch(error => {
            console.log('There has been an error');
            console.error(error);
          });
}
```

### Checking if the SDK Was Initialized

There is a convenience function that is exposed to check if the SDK was registered successfully:

```jsx
import ExactTarget from 'react-native-exact-target';

...

componentDidMount() {
    let isExactTargetInitialized = ExactTarget.isSDKInitialized();
}

```

### Listening for Events

We expose an `eventEmitter` which a developer can use to listen in on various JB4A-SDK events.  Note that `eventEmitter` will return `null` if the SDK was not properly initialized.

Please be sure to remove listeners on your `componentWillUnmount`.

### Push Notifications

**Note**: This is still unstable and untested. Please use with caution.

```jsx
import ExactTarget from 'react-native-exact-target';

...

componentDidMount() {
  this.pushNotificationListener = ExactTarget.eventEmitter.addListener(
    'ET:PUSH_NOTIFICATION_RECEIVED',
    (payload) => {
      // Handle the payload as you see fit
      console.log(payload);
    }
  );
}

componentWillUnmount() {
  if (this.pushNotificationListener) {
    this.pushNotificationListener.remove();
  }
}

```

### Resetting Badge Count (iOS Only)

*Note*: This will no-op if the SDK was not properly initialized or if attempted from Android

```jsx
import ExactTarget from 'react-native-exact-target';

...

ExactTarget.resetBadgeCount();
```

### Automatically Display an Alert if a Push Notification is Received (iOS Only)

*Note*: This will no-op if the SDK was not properly initialized or if attempted from Android

```jsx
import ExactTarget from 'react-native-exact-target';

...

ExactTarget.shouldDisplayAlertViewIfPushReceived(true);
```

## Credits

This library was scaffolded by [create-react-native-library](https://github.com/frostney/react-native-create-library)
  
