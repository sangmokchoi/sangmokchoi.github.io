import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pp/Model/Image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Constant.dart';
import '../DataSource/FIrebaseDS.dart';

class HomeViewModel {

  final FirebaseDS _firebaseDS = FirebaseDS();

  PageController pageController = PageController(initialPage: 0, viewportFraction: 1 / 2);
  PageController profilePageController = PageController(viewportFraction: 0.9);

  Stream<List<ImageModel>> getImageStream() async* {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final Set<String> imagePaths = {}; // 중복 체크를 위한 Set
    final List<ImageModel> images = [];

    // Stream을 반환하여 이미지 목록을 비동기적으로 스트리밍합니다.
    yield* _firebaseDS.fetchAllImages(storage.ref(), imagePaths, images);
  }

  String getSubtitle(String key, AppLocalizations locale) {
    switch (key) {
      case 'letter':
        return locale.letterSubtitle;
      case 'muglite':
        return locale.mugliteSubtitle;
      case 'twp4bg':
        return locale.twp4bgSubtitle;
      case 'dnpp':
        return locale.dnppSubtitle;
      case 'jjgsr':
        return locale.jjgsrSubtitle;
      default:
        return '';
    }
  }

  String getAppStoreUrl(String key) {
    switch (key) {
      case 'letter':
        return 'https://apps.apple.com/app/%EB%B0%A4%ED%8E%B8%EC%A7%80-%EB%A7%88%EC%9D%8C%EC%9D%84-%EC%A3%BC%EA%B3%A0-%EB%B0%9B%EB%8A%94-%ED%8E%B8%EC%A7%80-%ED%95%9C-%ED%86%B5/id6448700074';
      case 'muglite':
        return 'https://apps.apple.com/app/mug-lite/id6450693152';
      case 'twp4bg':
        return 'https://apps.apple.com/us/app/trip-sketcher/id6464154800';
      case 'dnpp':
        return 'https://apps.apple.com/app/%ED%95%91%ED%90%81%ED%94%8C%EB%9F%AC%EC%8A%A4/id6478840964';
      case 'jjgsr':
        return 'https://apps.apple.com/app/%EC%B0%8D%EC%8B%A0%EA%B0%95%EB%A6%BC/id6504901441';
      default:
        return '';
    }
  }

  String getPlayStoreUrl(String key) {
    switch (key) {
      case 'dnpp':
        return 'https://play.google.com/store/apps/details?id=com.simonwork.dnpp.dnpp';
      case 'jjgsr':
        return 'https://play.google.com/store/apps/details?id=com.app.JJGSR';
      default:
        return '';
    }
  }

  String getGitHubUrl(String key) {
    switch (key) {
      case 'letter':
        return 'https://github.com/sangmokchoi/letter-from-late-night';
      case 'muglite':
        return 'https://github.com/sangmokchoi/mug-lite';
      case 'twp4bg':
        return 'https://github.com/sangmokchoi/Trip-Sketcher';
      case 'dnpp':
        return 'https://github.com/sangmokchoi/DNPP';
      case 'jjgsr':
        return 'https://github.com/sangmokchoi/JJGSR';
      default:
        return '';
    }
  }

  String getAppDescription(String key, AppLocalizations locale) {
    switch (key) {
      case 'letter':
        return locale.letterDescription;
      case 'muglite':
        return locale.mugliteDescription;
      case 'twp4bg':
        return locale.twp4bgDescription;
      case 'dnpp':
        return locale.dnppDescription;
      case 'jjgsr':
        return locale.jjgsrDescription;
      default:
        return '';
    }
  }

}

final homeViewModelProvider = Provider<HomeViewModel>((ref) {
  return HomeViewModel();
});

final imageStreamProvider = StreamProvider<List<ImageModel>>((ref) {
  final homeViewModel = ref.watch(homeViewModelProvider);
  return homeViewModel.getImageStream();
});


class PageViewNotifier extends StateNotifier<int> {
  PageViewNotifier() : super(0);

  void setPage(int pageIndex) {
    state = pageIndex;
  }
}

final pageViewNotifierProvider = StateNotifierProvider.autoDispose.family<PageViewNotifier, int, String>((ref, category) {
  return PageViewNotifier();
});
