import 'dart:io' show Platform;

import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:flutter/widgets.dart';
import 'package:mudkip_frontend/mudkipc.dart';

import 'package:mudkip_frontend/theme/theme_constants.dart';
import 'package:mudkip_frontend/theme/theme_manager.dart';
import 'package:mudkip_frontend/main.dart';

/// # `mixin` UniversalBuilder
/// ## Mix this into a widget you want to be different on each platform.
/// There are currently three platform methods you can override:
/// - `buildAndroidApp`
/// - `buildWindowsApp`
/// - `buildMacOSApp`
mixin UniversalBuilder {
  static String? overridePlatform = "android";

  static Widget buildApp(ThemeManager themeProvider) {
    String platform = Platform.operatingSystem;
    if (overridePlatform != null) {
      platform = overridePlatform!;
    }
    switch (platform) {
      case "android":
        return buildAndroidApp(themeProvider);
      case "windows":
        return buildWindowsApp(themeProvider);
      case "macos":
        return buildMacOSApp(themeProvider);
      default:
        return buildAndroidApp(themeProvider);
    }
  }

  static Widget buildAndroidApp(ThemeManager themeProvider) {
    return material.MaterialApp.router(
        title: "Pokémon Manager",
        theme: MaterialTheme.lightTheme,
        darkTheme: MaterialTheme.darkTheme,
        themeMode: themeProvider.themeMode,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
          Locale('ja', 'JP'),
          Locale('ko', 'KR'),
          Locale('es', 'ES'),
          Locale('zh', 'CN'),
          Locale('it', 'IT')
        ],
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider);
  }

  static Widget buildWindowsApp(ThemeManager themeProvider) {
    return fluent.FluentApp.router(
        theme: FluentTheme.lightTheme,
        darkTheme: FluentTheme.darkTheme,
        themeMode: themeProvider.themeMode,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('fr', 'FR'),
          Locale('ja', 'JP'),
          Locale('ko', 'KR'),
          Locale('es', 'ES'),
          Locale('zh', 'CN'),
          Locale('it', 'IT')
        ],
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider);
  }

  static Widget buildMacOSApp(ThemeManager themeProvider) {
    return macos.MacosApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider);
  }

  Widget build(BuildContext context) {
    String platform = Platform.operatingSystem;
    if (overridePlatform != null) {
      platform = overridePlatform!;
    }
    switch (platform) {
      case "android":
        return buildAndroid(context);
      case "windows":
        return buildWindows(context);
      case "macos":
        return buildMacOS(context);
      default:
        return buildAndroid(context);
    }
  }

  Widget buildAndroid(BuildContext context);
  Widget buildWindows(BuildContext context);
  Widget buildMacOS(BuildContext context);
}

class UniversalCircularProgressIndicator extends StatelessWidget
    with UniversalBuilder {
  const UniversalCircularProgressIndicator({super.key});
  @override
  Widget buildAndroid(BuildContext context) {
    return const material.CircularProgressIndicator();
  }

  @override
  Widget buildMacOS(BuildContext context) {
    return const macos.ProgressCircle();
  }

  @override
  Widget buildWindows(BuildContext context) {
    return const fluent.ProgressRing();
  }
}

class UniversalLinearProgressIndicator extends StatelessWidget
    with UniversalBuilder {
  const UniversalLinearProgressIndicator({super.key});

  @override
  Widget buildAndroid(BuildContext context) {
    return const material.LinearProgressIndicator();
  }

  @override
  Widget buildMacOS(BuildContext context) {
    return const macos.ProgressCircle();
  }

  @override
  Widget buildWindows(BuildContext context) {
    return const fluent.ProgressBar();
  }
}

class UniversalChip extends StatelessWidget with UniversalBuilder {
  final String text;
  final Widget? avatar;
  const UniversalChip({super.key, this.avatar, required this.text});

  @override
  Widget buildAndroid(BuildContext context) {
    return material.Chip(
      label: Text(text),
      avatar: avatar,
    );
  }

  @override
  Widget buildMacOS(BuildContext context) {
    Widget child = const material.Placeholder();
    if (avatar != null) {
      child = material.Padding(
        padding: const EdgeInsets.all(2.0),
        child: Flex(
          textDirection: material.TextDirection.ltr,
          direction: material.Axis.horizontal,
          mainAxisSize: material.MainAxisSize.min,
          children: [
            AspectRatio(aspectRatio: 1.0, child: avatar!),
            const SizedBox(width: 4.0),
            Text(text),
          ],
        ),
      );
    } else {
      child = Text(text);
    }
    return macos.PushButton(
      controlSize: macos.ControlSize.regular,
      child: child,
    );
  }

  @override
  Widget buildWindows(BuildContext context) {
    return fluent.Button(
      onPressed: () {},
      child: Flex(
        mainAxisSize: material.MainAxisSize.min,
        direction: material.Axis.horizontal,
        children: [
          if (avatar != null) avatar!,
          Text(text),
        ],
      ),
    );
  }
}

class UniversalButton extends StatelessWidget with UniversalBuilder {
  final Function onPressed;
  final Widget? child;
  const UniversalButton({super.key, this.child, required this.onPressed});

  @override
  Widget buildAndroid(BuildContext context) {
    return material.ElevatedButton(
      onPressed: () => onPressed(),
      child: child,
    );
  }

  @override
  Widget buildMacOS(BuildContext context) {
    return macos.PushButton(
      onPressed: () => onPressed(),
      controlSize: macos.ControlSize.regular,
      child: child ?? const Text(""),
    );
  }

  @override
  material.Widget buildWindows(BuildContext context) {
    return fluent.Button(
      onPressed: () => onPressed(),
      child: child ?? const Text(""),
    );
  }
}

class UniversalSearchBar extends StatefulWidget {
  const UniversalSearchBar({super.key});

  @override
  State<UniversalSearchBar> createState() => _UniversalSearchBarState();
}

class _UniversalSearchBarState extends State<UniversalSearchBar>
    with UniversalBuilder {
  OverlayPortalController overlayPortalController = OverlayPortalController();
  GlobalKey searchBoxKey = GlobalKey();
  Offset searchSuggestionsOffset = Offset.zero;
  List<Suggestion> suggestions = [];

  @override
  Widget buildAndroid(BuildContext context) {
    final showRail = MediaQuery.of(context).size.width >= 600;
    material.SearchController controller = material.SearchController();
    if (showRail) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 400,
          child: material.SearchAnchor.bar(
            suggestionsBuilder: (context, search) async {
              return (await MudkiPC.pachinko.generateSuggestions(search.text))
                  .map((Suggestion e) => e.getForMaterial())
                  .toList();
            },
            barLeading: const SizedBox(
                height: 100,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [])),
          ),
        ),
      );
    } else {
      material.SearchAnchor(
          searchController: controller,
          viewLeading: const Wrap(alignment: WrapAlignment.start, children: []),
          builder: (context, search) {
            return material.IconButton(
                onPressed: () {
                  controller.openView();
                },
                icon: const Icon(size: 30, material.Icons.search));
          },
          suggestionsBuilder: (context, search) async {
            return (await MudkiPC.pachinko.generateSuggestions(search.text))
                .map((Suggestion e) => e.getForMaterial())
                .toList();
          });
    }
    return const Placeholder();
  }

  @override
  Widget buildWindows(BuildContext context) {
    // This is a hack. I am using a global key attached to a TextBox in conjunction with an OverlayPortal. The issue with AutoSuggestBox is that it requires a list of items to be passed in right on creation, which is not possible with the data being fetch asynchronously. Why must I have to do this? Why can't AutoSuggestBox just have a suggestionsBuilder instead of a simple list? If you are reading this and are a part of the fluent_ui team, please change this or help me fix the problem.
    return OverlayPortal(
        controller: overlayPortalController,
        overlayChildBuilder: (context) {
          List<fluent.ListTile> finalSuggestions =
              suggestions.map((Suggestion e) => e.getForFluent()).toList();
          return Positioned(
              width: 300,
              height: 400,
              top: searchSuggestionsOffset.dy,
              left: searchSuggestionsOffset.dx,
              child:
                  fluent.Acrylic(child: ListView(children: finalSuggestions)));
        },
        child: fluent.TextBox(
          textAlignVertical: TextAlignVertical.center,
          key: searchBoxKey,
          onEditingComplete: () => overlayPortalController.hide(),
          onTap: () => showSuggestions(),
          onTapOutside: (event) => overlayPortalController.hide(),
          onChanged: (value) => updateSuggestions(value),
        ));
  }

  void showSuggestions() {
    // This gets the offset of the search box and then shows the overlay portal at the bottom of the search box.
    final RenderBox box =
        searchBoxKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero) + Offset(0, box.size.height);
    setState(() {
      searchSuggestionsOffset = offset;
    });
    overlayPortalController.show();
  }

  @override
  Widget buildMacOS(BuildContext context) {
    return OverlayPortal(
        controller: overlayPortalController,
        overlayChildBuilder: (context) {
          List<macos.MacosListTile> finalSuggestions =
              suggestions.map((Suggestion e) => e.getForMacOS()).toList();
          return Positioned(
              width: 300,
              height: 400,
              top: searchSuggestionsOffset.dy,
              left: searchSuggestionsOffset.dx,
              child: macos.MacosOverlayFilter(
                  borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                  child: ListView(children: finalSuggestions)));
        },
        child: macos.MacosTextField(
          textAlignVertical: TextAlignVertical.center,
          key: searchBoxKey,
          onEditingComplete: () => overlayPortalController.hide(),
          onTap: () => showSuggestions(),
          onSubmitted: (value) => overlayPortalController.hide(),
          onChanged: (value) => updateSuggestions(value),
        ));
  }

  void updateSuggestions(String query) {
    MudkiPC.pachinko.generateSuggestions(query).then((List<Suggestion> value) {
      if (value == []) {
        if (overlayPortalController.isShowing) overlayPortalController.hide();
      }
      setState(() {
        if (!overlayPortalController.isShowing) showSuggestions();
        setState(() {
          suggestions = value;
        });
      });
    });
  }
}
