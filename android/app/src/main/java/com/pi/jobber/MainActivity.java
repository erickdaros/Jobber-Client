package com.pi.jobber;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String ACTION_CHANNEL = "method.channel";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    new MethodChannel(getFlutterView(), ACTION_CHANNEL).setMethodCallHandler(
        (call, result) -> {
          if (call.method.equals("minimize")) {
            moveTaskToBack(true);
            result.success(true);
          } else {
            result.notImplemented();
          }
        }
    );
  }
}
