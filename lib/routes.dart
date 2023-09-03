import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:indoor_localization_web/main.dart';
import 'package:indoor_localization_web/pages/erro_page.dart';
import 'package:indoor_localization_web/pages/map_editor_page.dart';
import 'package:responsive_framework/responsive_framework.dart';

final GoRouter router = GoRouter(
  errorBuilder: (context, state) {
    return const ErrorPage(error: 'Hiba történt, nincs ilyen oldal');
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return _responsiveWrapper(
          context,
          child: const MyHomePageReset(),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'map-editor/:id',
          builder: (BuildContext context, GoRouterState state) {
            String mapId = state.pathParameters['id']!;

            return _responsiveWrapper(
              context,
              child: MapEditorPage(mapId: mapId),
            );
          },
        ),
      ],
    ),
  ],
);

Widget _responsiveWrapper(BuildContext context, {required Widget child}) {
  return MaxWidthBox(
    maxWidth: 1920,
    background: Container(color: const Color(0xFFF5F5F5)),
    child: ResponsiveScaledBox(
      width: ResponsiveValue<double>(context, conditionalValues: [
        Condition.equals(name: MOBILE, value: 450),
        Condition.between(start: 800, end: 1100, value: 800),
        Condition.between(start: 1000, end: 1200, value: 1000),
      ]).value,
      child: BouncingScrollWrapper.builder(context, child, dragWithMouse: true),
    ),
  );
}
