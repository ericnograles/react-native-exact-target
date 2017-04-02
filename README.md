# react-native-exact-target

## Important Note

This project is still in alpha stages and is not fit for production usage yet. Please stay tuned as we work towards our first RC.

If you're in a crunch and would like to use this, please feel free to fork or contribute.

## Introduction

react-native-exact-target provides bridging functionality to Salesforce Marketing Cloud's Exact Target SDK, aka the Journey Builder for iOS and Journey Builder for Android

## Getting started

`$ npm install react-native-exact-target --save`

### Mostly automatic installation

`$ react-native link react-native-exact-target`

#### Android (Mostly Automatic Install Cont'd.)

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


### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-exact-target` and add `RNExactTarget.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNExactTarget.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

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

## Usage

### Example App

This repo comes with an ExampleApp that implements the functionality listed below. Please feel free to clone the repo and run the ExampleApp to tinker with various settings.

### Registering an App

* Please follow the instructions set forth by the <a href="https://github.com/ericnograles/LearningAppIos/blob/master/README.md#create-your-apps-in-the-app-center" target="_blank">Salesforce Marketing Cloud iOS Learning App</a>.
  * Take note of the resulting App ID and Access Token

### Initializing

Typically, you'll want to initialize ExactTarget on the `componentDidMount` of your App.js, like so:
    ```jsx
    import ExactTarget from 'react-native-exact-target';
    
    componentDidMount() {
        ExactTarget.initializePushManager({
              appId: 'your-app-id',
              accessToken: 'your-app-access-token',
              enableAnalytics: false,
              enableLocationServices: false,
              enableProximityServices: false,
              enableCloudPages: false,
              enablePIAnalytics: false
            });
    }
    ```

### Resetting Badge Count (iOS Only)

```jsx
import ExactTarget from 'react-native-exact-target';

...

ExactTarget.resetBadgeCount();
```

### Automatically Display an Alert if a Push Notification is Received (iOS Only)

```jsx
import ExactTarget from 'react-native-exact-target';

...

ExactTarget.shouldDisplayAlertViewIfPushReceived(true);
```

## Credits

This library was scaffolded by [create-react-native-library](https://github.com/frostney/react-native-create-library)
  
