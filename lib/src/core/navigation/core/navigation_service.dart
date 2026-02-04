import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

BuildContext? get globalContext => rootNavigatorKey.currentContext;
