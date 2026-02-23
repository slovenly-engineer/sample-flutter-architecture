import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 3,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
