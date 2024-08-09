import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// localization 용
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'View/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final runnableApp = _buildRunnableApp(
    isWeb: kIsWeb,
    webAppWidth: 480.0,
    app: ProviderScope(
      child: PP(),
    ),
  );

  runApp(runnableApp);

}

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = Locale('en');

  LocaleNotifier(this._locale);

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}

// ChangeNotifierProvider 정의
final localeProvider = ChangeNotifierProvider<LocaleNotifier>((ref) {
  return LocaleNotifier(Locale('en')); // 초기 로케일 설정
});

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PP extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final locale = ref.watch(localeProvider).locale;

    return MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('ko'),
        ],
        locale: locale,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(colorSchemeSeed: Colors.white, fontFamily: 'NotoSansKR'),
        home: EntryWidget(),
      );
  }
}

Widget EntryWidget() {
  return FlutterSplashScreen(
    duration: const Duration(milliseconds: 2000),
    nextScreen: HomeView(),
    backgroundColor: Colors.white,
    splashScreenBody: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator(),),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Loading..', style: TextStyle(fontSize: 16.0, color: Colors.grey),),
          )
        ],
      ),
    ),
  );
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Center(
    child: ClipRect(
      child: SizedBox(
        width: webAppWidth,
        child: app,
      ),
    ),
  );
}