import 'package:sample/src/feature/app/sample.dart';
import 'package:sample/src/feature/app/model/dependencies.dart';
import 'package:sample/src/feature/app/widget/dependencies_scope.dart';
import 'package:flutter/material.dart';

/// [App] is an entry point to the application.
class App extends StatelessWidget {
  const App({required this.result, super.key});

  /// Running this function will result in attaching
  /// corresponding [RenderObject] to the root of the tree.
  void attach([VoidCallback? callback]) {
    callback?.call();
    runApp(this);
  }

  /// The initialization result from the [InitializationProcessor]
  /// which contains initialized dependencies.
  final InitializationResult result;

  @override
  Widget build(BuildContext context) => DependenciesScope(
        dependencies: result.dependencies,
        child: Sample(
          notifications: result.dependencies.notifications,
          preferences: result.dependencies.preferences,
        ),
      );
}
