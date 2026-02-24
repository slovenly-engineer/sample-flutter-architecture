import 'package:flutter/material.dart';

import '../ui/components/app_loading_indicator.dart';

/// スプラッシュ画面（Feature非依存）。
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: AppLoadingIndicator()));
  }
}
