package com.nadia.e_lorry

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    FlutterMain.startInitialization(this)
      super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }
}
