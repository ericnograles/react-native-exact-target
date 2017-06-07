
package com.exacttarget.etpushsdk.reactnative;

// Android stuff
import android.app.Application;
import android.support.annotation.Nullable;
import android.content.Context;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.RCTNativeAppEventEmitter;

// ExactTarget SDK
import com.exacttarget.etpushsdk.ETAnalytics;
import com.exacttarget.etpushsdk.ETLocationManager;
import com.exacttarget.etpushsdk.ETException;
import com.exacttarget.etpushsdk.ETLogListener;
import com.exacttarget.etpushsdk.ETNotificationBuilder;
import com.exacttarget.etpushsdk.ETNotifications;
import com.exacttarget.etpushsdk.ETPush;
import com.exacttarget.etpushsdk.ETPushConfig;
import com.exacttarget.etpushsdk.ETPushConfigureSdkListener;
import com.exacttarget.etpushsdk.ETRequestStatus;
import com.exacttarget.etpushsdk.data.Attribute;
import com.exacttarget.etpushsdk.data.Region;
import com.exacttarget.etpushsdk.event.BeaconResponseEvent;
import com.exacttarget.etpushsdk.event.GeofenceResponseEvent;
import com.exacttarget.etpushsdk.event.PushReceivedEvent;
import com.exacttarget.etpushsdk.event.RegistrationEvent;
import com.exacttarget.etpushsdk.util.EventBus;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.maps.model.LatLng;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.Locale;
import java.util.TimeZone;


// Android
import android.util.Log;

public class RNExactTargetModule extends ReactContextBaseJavaModule implements ETLogListener, ETPushConfigureSdkListener {

  private Application mainApplication;
  private static final String TAG = "~#RNExactTarget";
  private static final LinkedHashSet<EtPushListener> listeners = new LinkedHashSet<>();
  private static ETPush etPush;
  private final ReactApplicationContext reactContext;
  private boolean enableLocationServices = false;

  public RNExactTargetModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  private void sendEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
    reactContext
            .getJSModule(RCTNativeAppEventEmitter.class)
            .emit(eventName, params);
  }

  @ReactMethod
  public void initializePushManager(ReadableMap config, Promise promise) {
    // Grab the application
    this.mainApplication = (Application) reactContext.getApplicationContext();

    // Set configs for ExactTarget
    String appId = config.getString("appId");
    String accessToken = config.getString("accessToken");
    String gcmSenderId = config.getString("gcmSenderId");
    boolean enableAnalytics = config.getBoolean("enableAnalytics");
    boolean enableProximityServices = config.getBoolean("enableProximityServices");
    boolean enableCloudPages = config.getBoolean("enableCloudPages");
    boolean enablePIAnalytics = config.getBoolean("enablePIAnalytics");
    enableLocationServices = config.getBoolean("enableLocationServices");

    // ExactTarget registration
    EventBus.getInstance().register(this);
    try {
      ETPush.configureSdk(new ETPushConfig.Builder(this.mainApplication)
                      .setEtAppId(appId)
                      .setAccessToken(accessToken)
                      .setGcmSenderId(gcmSenderId)
                      .setLogLevel(Log.VERBOSE)
                      .setAnalyticsEnabled(enableAnalytics)
                      .setLocationEnabled(enableLocationServices)
                      .setPiAnalyticsEnabled(enablePIAnalytics)
                      .setCloudPagesEnabled(enableCloudPages)
                      .setProximityEnabled(enableProximityServices)
                      .build()
              , this);
      promise.resolve(true);
    } catch (ETException e) {
      Log.e(TAG, e.getMessage(), e);
      promise.reject(TAG, e.getMessage());
    }
  }

  @Override
  public String getName() {
    return "RNExactTarget";
  }

  /**
   * Called when configureSdk() has successfully completed.
   * <p/>
   * When the readyAimFire() initialization is completed, start watching at beacon messages.
   *
   * @param etPush          a ready-to-use instance of ETPush.
   * @param etRequestStatus an additional status field regarding SDK readiness.
   */
  @Override
  public void onETPushConfigurationSuccess(final ETPush etPush, final ETRequestStatus etRequestStatus) {
    RNExactTargetModule.etPush = etPush;
    ETAnalytics.trackPageView("data://ReadyAimFireCompleted", "Marketing Cloud SDK Initialization Complete");

    // If there was an user recoverable issue with Google Play Services then show a notification to the user
    int googlePlayServicesStatus = etRequestStatus.getGooglePlayServiceStatusCode();
    String statusMessage = GoogleApiAvailability.getInstance().getErrorString(googlePlayServicesStatus);
    boolean userResolvableError = GoogleApiAvailability.getInstance().isUserResolvableError(googlePlayServicesStatus);
    boolean googlePlayServicesAvailable = googlePlayServicesStatus == ConnectionResult.SUCCESS;

    Log.i(TAG, String.format(Locale.ENGLISH, "Google Play Services Availability: %s", statusMessage));
    if (!googlePlayServicesAvailable) {
      Log.i(TAG, String.format(Locale.ENGLISH, "Is user resolvable? %s", String.valueOf(userResolvableError)));
      if (userResolvableError) {
        GoogleApiAvailability.getInstance().showErrorNotification(this.mainApplication, googlePlayServicesStatus);
      }
    }

    // TODO: Note that there has been observed issues with the code below, it may crash your Android app
    if (enableLocationServices) {
      String sdkState;
      try {
        sdkState = ETPush.getInstance().getSDKState();
        ETLocationManager.getInstance().startWatchingLocation();
      } catch (ETException e) {
        sdkState = e.getMessage();
      }
      Log.v(TAG, sdkState); // Write the current SDK State to the Logs.
    }

    if (!listeners.isEmpty()) { // Tell our listeners that the SDK is ready for use
      for (EtPushListener listener : listeners) {
        if (listener != null) {
          listener.onReadyForPush(etPush);
        }
      }
      listeners.clear();
    }
  }

  @Override
  public void onETPushConfigurationFailed(ETException etException) {
    Log.e(TAG, etException.getMessage(), etException);
  }

  @Override
  public void out(int severity, String tag, String message, @Nullable Throwable throwable) {
        /*
         * Using this method you can interact with SDK log output.
         * Severity is populated with log levels like Log.VERBOSE, Log.INFO etc.
         * Message, is populated with the actual log output text.
         * Tag, is a free form string representing the log tag you've selected.
         * Finally, the optional Throwable Throwable represents a thrown exception.
         */

        /*
         * Assuming you have crashytics enabled for your app, the following code would send
         * log data to Crashytics in the event that the log's severity is ERROR or ASSERT
         */

    if (throwable != null) {
      // We have an exception to log:
      // Commenting out all references to Crashlytics.
      // Crashlytics.logException(throwable);
    }

    switch (severity) {
      case Log.ERROR:
        Log.e(tag, message);
        // Crashlytics.log(severity, tag, message);
        break;
      case Log.ASSERT:
        Log.wtf(tag, message);
        // Crashlytics.log(severity, tag, message);
        try {
          // If we're logging a failed ASSERT, also grab the getSDKState() data and log that as well
          Log.v("SDKState Information", ETPush.getInstance().getSDKState());
          // Crashlytics.log(ETPush.getInstance().getSDKState());
        } catch (ETException etException) {
          Log.v("ErrorGettingSDKState", etException.getMessage());
          // Crashlytics.log(String.format(Locale.ENGLISH, "Error Getting SDK State: %s", etException.getMessage()));
        }
        break;
      default:
        Log.v(tag, message);
    }
  }

  @SuppressWarnings("unused, unchecked")
  public void onEvent(final PushReceivedEvent event) {
    // TODO: Determine the type of PushReceivedEvent -- e.g. Geofence, Push, Local?
    WritableMap params = Arguments.fromBundle(event.getPayload());
    sendEvent((ReactContext) reactContext, "ET:PUSH_NOTIFICATION_RECEIVED", params);
  }

  public interface EtPushListener {
    void onReadyForPush(ETPush etPush);
  }
}