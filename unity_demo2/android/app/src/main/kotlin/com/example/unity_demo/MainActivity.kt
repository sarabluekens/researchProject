// import com.xraph.plugin.flutter_unity_widget.UnityPlayerUtils
// import com.unity3d.player.UnityPlayer
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel

// import io.flutter.embedding.android.FlutterActivity

// class MainActivity: FlutterActivity() {

//     @JvmField
//     var mUnityPlayer: java.lang.Object? = null

//     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "unity.hack").setMethodCallHandler {
//                 call, result ->
//             if (call.method == "init") {
//                 mUnityPlayer = UnityPlayerUtils.unityPlayer as java.lang.Object?
//                 result.success(0);
//             }
//         }

//     }
package com.example.unity_demo

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}



// }
