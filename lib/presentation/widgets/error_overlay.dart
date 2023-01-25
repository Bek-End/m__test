import 'package:flutter/material.dart';
import 'package:m_test/main.dart';

void showError(String text) {
  globalKey.currentState?.overlay?.insert(
    ErrorOverlayLoader(text: text),
  );
}

class ErrorOverlayLoader extends OverlayEntry {
  final String text;

  ErrorOverlayLoader({
    required this.text,
  }) : super(
          builder: (_) {
            return const SizedBox();
          },
        );

  Widget _buider(BuildContext context) {
    return ErrorLoaderWidget(overlayEntry: this, text: text);
  }

  @override
  WidgetBuilder get builder => _buider;
}

class ErrorLoaderWidget extends StatefulWidget {
  final ErrorOverlayLoader overlayEntry;
  final String text;

  const ErrorLoaderWidget({
    required this.overlayEntry,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  State<ErrorLoaderWidget> createState() => _ErrorLoaderWidgetState();
}

class _ErrorLoaderWidgetState extends State<ErrorLoaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
    value: 0,
  );
  late Animation<Offset> offset = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 0.5),
  ).animate(animationController);

  void _init() async {
    await animationController.forward();
    await Future.delayed(const Duration(seconds: 4));
    await animationController.reverse();
    widget.overlayEntry.remove();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: topPadding + 32,
      left: 20,
      right: 20,
      child: FadeTransition(
        opacity: animationController,
        child: SlideTransition(
          position: offset,
          child: Material(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
