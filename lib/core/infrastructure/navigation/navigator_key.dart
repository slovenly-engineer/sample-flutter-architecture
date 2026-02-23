import 'package:flutter/material.dart';

/// アプリ全体で使用するGlobalKey定義。
/// BuildContextなしでNavigatorやScaffoldMessengerにアクセスするために使用。
final rootNavigatorKey = GlobalKey<NavigatorState>();
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
