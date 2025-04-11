import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';
import 'package:reown_appkit/reown_appkit.dart';

class DeepLinkHandler {
  static const _methodChannel = MethodChannel('com.peopleapp.android/methods');
    // Platform.isAndroid
    //     ? 'com.peopleapp.android/methods'
    //     : 'com.peopleapp.ios/methods',
  // );
  static const _eventChannel = EventChannel('com.peopleapp.android/events');
    // Platform.isAndroid
    //     ? 'com.peopleapp.android/events'
    //     : 'com.peopleapp.ios/events',
  // );
  static final waiting = ValueNotifier<bool>(false);
  static late IReownAppKitModal _appKitModal;

  static void initListener() {
    if (kIsWeb) return;
    try {
      _eventChannel.receiveBroadcastStream().listen(
            _onLink,
            onError: _onError,
          );
    } catch (e) {
      debugPrint('[SampleDapp] checkInitialLink $e');
    }
  }

  static void init(IReownAppKitModal appKitModal) {
    if (kIsWeb) return;
    _appKitModal = appKitModal;
  }

  static void checkInitialLink() {
    if (kIsWeb) return;
    try {
      _methodChannel.invokeMethod('initialLink');
    } catch (e) {
      debugPrint('[SampleDapp] checkInitialLink $e');
    }
  }

  static Uri get nativeUri =>
      Uri.parse(_appKitModal.appKit!.metadata.redirect?.native ?? '');
  static Uri get universalUri =>
      Uri.parse(_appKitModal.appKit!.metadata.redirect?.universal ?? '');
  static String get host => universalUri.host;

  static void _onLink(dynamic link) async {
    debugPrint('[SampleDapp] _onLink $link');
    if (link == null) return;
    final handled = await _appKitModal.dispatchEnvelope(link);
    if (!handled) {
      debugPrint('[SampleDapp] _onLink not handled by AppKit');
    }
  }

  static void _onError(dynamic error) {
    debugPrint('[SampleDapp] _onError $error');
    waiting.value = false;
  }
}
