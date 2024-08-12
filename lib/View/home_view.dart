import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pp/Constant.dart';
import 'package:pp/Model/Image.dart';
import 'package:pp/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/Experience.dart';
import '../ViewModel/HomeViewModel.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  Map<String, bool> _expandedState = {}; // 각 카테고리의 확장 상태를 저장

  bool isLangEng = true;
  int temp = 0;

  Future<void> toggleLang(BuildContext context) async {
    setState(() {
      isLangEng = !isLangEng;
      final newLocale = isLangEng ? Locale('en') : Locale('ko');
      ref.read(localeProvider).setLocale(newLocale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageAsyncValue = ref.watch(imageStreamProvider);
    final homeVM = ref.watch(homeViewModelProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
        body: Column(
          children: [
            // language Change
            Column(
              children: [
                Container(
                  height: 80,
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // github logo
                          Container(
                            margin: EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.transparent),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  // 그림자 색상
                                  spreadRadius: 0.1,
                                  // 그림자 확산 정도
                                  blurRadius: 3,
                                  // 그림자 흐림 정도
                                  offset: Offset(0, 3), // 그림자의 오프셋(위치)
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                final url = Uri.parse(kMyGitHubUrl);

                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                foregroundImage: AssetImage('images/GitHub Icon.png')
                                as ImageProvider<Object>,
                              ),
                            ),
                          ),
                          Text(
                            localizations.myName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Language:'),
                          TextButton(
                              onPressed: () {
                                toggleLang(context);
                              },
                              child: Text(
                                localizations.language,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: imageAsyncValue.when(
                data: (images) {
                  // 카테고리별로 이미지 그룹화
                  final Map<String, List<ImageModel>> categoryMap = {};
                  for (var image in images) {
                    if (!categoryMap.containsKey(image.appName)) {
                      categoryMap[image.appName] = [];
                    }
                    categoryMap[image.appName]!.add(image);
                  }

                  return Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent, // 구분선 제거
                    ),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: ListView(
                        children: categoryMap.keys.map((category) {

                          final pageViewNotifier =
                              ref.watch(pageViewNotifierProvider(category));
                          final pageViewNotifierController = ref
                              .read(pageViewNotifierProvider(category).notifier);

                          final categoryImages = categoryMap[category]!;

                          if (!_expandedState.containsKey(category)) {
                            _expandedState[category] = true;
                          }

                          if (category == 'me.jpeg') {
                            // Profile Image & brief Introduction
                            return ProfileWidget(
                              categoryImages: categoryImages,
                              localizations: localizations,
                              homeVM: homeVM,
                            );
                          } else {
                            final appName = kAppNameList[category]!;
                            final _scrollController = ScrollController();
                            // App List
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: ExpansionTile(
                                initiallyExpanded: _expandedState[category]!,
                                title: Text(
                                  category,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                subtitle: Text(
                                  homeVM.getSubtitle(appName, localizations),
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0),
                                ),
                                trailing: Icon(
                                  _expandedState[category] ?? true
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                onExpansionChanged: (bool expanded) {
                                  setState(() {
                                    _expandedState[category] = expanded;
                                  });
                                },
                                expandedCrossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 5.0,
                                        bottom: 0.0,
                                        left: 18.0,
                                        right: 18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 스크린샷
                                        Column(
                                          children: [
                                            Container(
                                              height:
                                              MediaQuery.of(context).size.height *
                                                  0.43,
                                              margin: EdgeInsets.only(bottom: 8.0),
                                              child: PageView.builder(
                                                padEnds: false,
                                                itemCount: categoryImages.length,
                                                controller: homeVM.pageController,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (BuildContext context,
                                                    int index) {
                                                  var _padding = EdgeInsets.all(0.0);

                                                  if (index == 0) {
                                                    _padding =
                                                        EdgeInsets.only(left: 20.0);
                                                  } else if (index ==
                                                      categoryImages.length - 1) {
                                                    _padding =
                                                        EdgeInsets.only(right: 20.0);
                                                  }

                                                  final image = categoryImages[index];
                                                  return Container(
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 8.0),
                                                    child: Image.network(
                                                      image.url,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  );
                                                },
                                                onPageChanged: (index) {
                                                  pageViewNotifierController
                                                      .setPage(index);
                                                },
                                              ),
                                            ),
                                            // dots
                                            Align(
                                              alignment: Alignment.center,
                                              child: AnimatedSmoothIndicator(
                                                activeIndex: pageViewNotifier,
                                                count: categoryImages.length - 1,
                                                effect: ScrollingDotsEffect(
                                                  dotHeight: 8.0,
                                                  dotWidth: 8.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // description
                                        Container(
                                          height: 250,
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              top: 15.0, bottom: 15.0, left: 20.0, right: 20.0),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 25.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(30),
                                          ),
                                          child: Scrollbar(
                                            thickness: 3.0,
                                            controller: _scrollController,
                                            thumbVisibility: true,
                                            child: SingleChildScrollView(
                                                controller: _scrollController,
                                                child: Text(
                                                    homeVM.getAppDescription(
                                                        appName, localizations))),
                                          ),
                                        ),
                                        // Download Link
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            'Download link',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        // store images
                                        Container(
                                          margin: EdgeInsets.only(bottom: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // AppStore Url
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final url = Uri.parse(
                                                        homeVM.getAppStoreUrl(
                                                            appName),
                                                      );
                                                      if (!await launchUrl(url)) {
                                                        throw Exception(
                                                            'Could not launch $url');
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                30),
                                                        border: Border.all(
                                                            color:
                                                                Colors.transparent),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(0.3),
                                                            // 그림자 색상
                                                            spreadRadius: 0.1,
                                                            // 그림자 확산 정도
                                                            blurRadius: 3,
                                                            // 그림자 흐림 정도
                                                            offset: Offset(0,
                                                                3), // 그림자의 오프셋(위치)
                                                          ),
                                                        ],
                                                      ),
                                                      child: CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                                'images/AppStore Icon.png')
                                                            as ImageProvider<
                                                                Object>,
                                                      ),
                                                    ),
                                                  ),
                                                  // PlayStore Url
                                                  if (homeVM.getPlayStoreUrl(
                                                          appName) !=
                                                      '')
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                30),
                                                        border: Border.all(
                                                            color:
                                                                Colors.transparent),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(0.3),
                                                            // 그림자 색상
                                                            spreadRadius: 0.1,
                                                            // 그림자 확산 정도
                                                            blurRadius: 3,
                                                            // 그림자 흐림 정도
                                                            offset: Offset(0,
                                                                3), // 그림자의 오프셋(위치)
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          final url = Uri.parse(
                                                            homeVM.getPlayStoreUrl(
                                                                appName),
                                                          );

                                                          if (!await launchUrl(
                                                              url)) {
                                                            throw Exception(
                                                                'Could not launch $url');
                                                          }
                                                        },
                                                        child: CircleAvatar(
                                                          backgroundImage: AssetImage(
                                                                  'images/PlayStore Icon.png')
                                                              as ImageProvider<
                                                                  Object>,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              // gitHub Icon
                                              Container(
                                                margin: EdgeInsets.only(left: 5.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                      color: Colors.transparent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      // 그림자 색상
                                                      spreadRadius: 0.1,
                                                      // 그림자 확산 정도
                                                      blurRadius: 3,
                                                      // 그림자 흐림 정도
                                                      offset: Offset(
                                                          0, 3), // 그림자의 오프셋(위치)
                                                    ),
                                                  ],
                                                ),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    final url = Uri.parse(
                                                      homeVM.getGitHubUrl(appName),
                                                    );

                                                    if (!await launchUrl(url)) {
                                                      throw Exception(
                                                          'Could not launch $url');
                                                    }
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    foregroundImage: AssetImage(
                                                            'images/GitHub Icon.png')
                                                        as ImageProvider<Object>,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Tech Stack Text
                                        Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8.0),
                                          child: Text(
                                            localizations.techStack,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
                                        ),
                                        // 기술 스택
                                        Container(
                                          height: kAppTechStack[appName]!
                                                  .keys
                                                  .length *
                                              35.0,
                                          child: ScrollConfiguration(
                                            behavior:
                                                ScrollConfiguration.of(context)
                                                    .copyWith(scrollbars: false),
                                            child: ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: kAppTechStack[appName]!
                                                  .keys
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final keys =
                                                    kAppTechStack[appName]!
                                                        .keys
                                                        .toList();
                                                final key = keys[index];
                                                final values =
                                                    kAppTechStack[appName]![
                                                        key]!; // List<String>

                                                return Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 7.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 8.0),
                                                        child: Text(
                                                          key,
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child:
                                                            ScrollConfiguration(
                                                          behavior:
                                                              ScrollConfiguration
                                                                      .of(context)
                                                                  .copyWith(
                                                                      scrollbars:
                                                                          false),
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              children: values
                                                                  .map((value) {
                                                                return Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10.0),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              3.0,
                                                                          horizontal:
                                                                              8.0),
                                                                  child: Text(
                                                                    '$value',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0),
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                15),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.3),
                                                                        // 그림자 색상
                                                                        spreadRadius:
                                                                            0.1,
                                                                        // 그림자 확산 정도
                                                                        blurRadius:
                                                                            2,
                                                                        // 그림자 흐림 정도
                                                                        offset: Offset(
                                                                            0,
                                                                            3), // 그림자의 오프셋(위치)
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }).toList(),
                      ),
                    ),
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),

    );
  }
}

class ProfileWidget extends ConsumerWidget {
  const ProfileWidget(
      {super.key,
      required this.categoryImages,
      required this.localizations,
      required this.homeVM
      });

  final List<ImageModel> categoryImages;
  final AppLocalizations localizations;
  final HomeViewModel homeVM;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final localeValue = ref.watch(localeProvider).locale;

    Map<String, Map<String, List<String>>> temp = ('$localeValue' == "en") ? kSelfIntroductionEnList : kSelfIntroductionKrList;

    final pages = temp.keys.map((category) {

      final details = temp[category]!;

      final experience = Experience(
        companies: Experience().getCompanies(details),
        durations: Experience().getDurations(details),
        performances: Experience().getPerformances(details),
      );

      final element = experience.companies != null
          ? [
        Expanded(
          child: ListView.builder(
            //physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: experience.companies?.length ?? 0,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${experience.companies?[index] ?? ""}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('${experience.durations?[index] ?? ""}',
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.0),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        experience.performances?[index] ?? "",
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]
          : details.keys.map((detailKey) {
        final values = details[detailKey]!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$detailKey:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              ...values.map(
                    (value) => Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 3.0),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList();

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade300,
        ),
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            SizedBox(height: 10.0),
            ...element
          ],
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: ClipOval(
                  child: Image.network(
                    categoryImages.first.url,
                    fit: BoxFit.fill,
                  ),
                ),
              ), // 프로필 사진
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      localizations.hello,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(
                      localizations.myKeywords,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      localizations.selfIntroduction,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmoothPageIndicator(
                  controller: homeVM.profilePageController,
                  count: 3,//pages.length,
                  axisDirection: Axis.vertical,
                  effect: ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 15,
                      expansionFactor: 10),
                  onDotClicked: (page) {
                    homeVM.profilePageController.animateToPage(page,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                ),
                Flexible(
                  flex: 9,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: homeVM.profilePageController,
                        scrollDirection: Axis.vertical,
                        itemCount: pages.length,
                        itemBuilder: (context, index) {
                          return pages[index];
                        },
                      ),
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(1.0),
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.1)
                            ],
                            stops: [0.0, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
