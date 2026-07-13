import 'package:flutter/material.dart';

/// Global navigator key — used by widget mixins that need a [BuildContext]
/// without one being passed explicitly (e.g. [BottomsheetWidget],
/// [TextWidget], [InputWidget]).
///
/// Wired into [MaterialApp.router] via the [navigatorKey] parameter.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
