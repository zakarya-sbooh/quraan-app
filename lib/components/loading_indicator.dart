import 'package:flutter/material.dart';
import 'package:quraanapp/constants/color.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: CircularProgressIndicator(
          color: green,
        ),
      ),
    );
  }
}
