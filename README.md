
# react-native-exact-target

## Getting started

`$ npm install react-native-exact-target --save`

### Mostly automatic installation

`$ react-native link react-native-exact-target`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-exact-target` and add `RNExactTarget.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNExactTarget.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNExactTargetPackage;` to the imports at the top of the file
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


## Usage
```javascript
import RNExactTarget from 'react-native-exact-target';

// TODO: What to do with the module?
RNExactTarget;
```

## Credits

This library was scaffolded by [create-react-native-library](https://github.com/frostney/react-native-create-library)
  
