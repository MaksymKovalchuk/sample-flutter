import 'package:flutter/material.dart';

/// Fallback UI shown when the app's one-shot initialization fails.
/// Displays the error and offers a retry button when a retry callback is given.
class SplashErrorApp extends StatefulWidget {
  const SplashErrorApp({
    required this.error,
    required this.stackTrace,
    this.retryInitialization,
    super.key,
  });

  final Object error;
  final StackTrace stackTrace;
  final Future<void> Function()? retryInitialization;

  @override
  State<SplashErrorApp> createState() => _SplashErrorAppState();
}

class _SplashErrorAppState extends State<SplashErrorApp> {
  final _inProgress = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _inProgress.dispose();
    super.dispose();
  }

  Future<void> _retry() async {
    _inProgress.value = true;
    await widget.retryInitialization!();
    _inProgress.value = false;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Initialization failed',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (widget.retryInitialization != null)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _retry,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.error}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${widget.stackTrace}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
