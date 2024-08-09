
const kMyGitHubUrl = "https://github.com/sangmokchoi";

const Map<String, String> kAppNameList = {
  '밤편지: 마음을 주고 받는 편지 한 통': "letter",
  'mug-lite': "muglite",
  'Trip Sketcher': "twp4bg",
  '핑퐁플러스': "dnpp",
  '찍신강림': "jjgsr"
};

const Map<String, Map<String, List<String>>> kAppTechStack = {
  "letter":
    {
      "UI": ["Storyboard", "(Widget) SwiftUI", "UIkit",],
      "Communication": ["Confluence", "Figma", "Jira"],
      "Database": ["Firebase Firestore", "UserDefaults"],
    "Firebase": ["Authentication", "App Check", "Cloud Functions", "Firestore"],
    "Google": ["AdMob", "Analytics"],
  },
  "muglite": {
    "UI": ["UIkit", "Storyboard"],
    "Communication": ["Confluence"],
    "Database": ["Firebase Firestore"],
    "Firebase": ["Authentication", "Firestore",],
    "API": ["Microsoft Azure Bing News API"],
    "Google": ["AdMob", "Analytics"],
    "In App Purchase": ["StoreKit"],
  },
  "twp4bg": {
    "UI": ["UIkit", "Storyboard"],
    "Communication": ["Confluence"],
    "Database": ["Realm DB"],
    "Firebase": ["Cloud Functions",],
    "Google": ["Analytics"],
  },
  "dnpp": {
    "UI": ["Figma",],
    "Communication": ["Confluence"],
    "Database": ["Firebase Firestore", "Firebase Realtime", "Firebase Storage", "shared_preferences"],
    "Firebase": ["Authentication", "App Check", "Cloud Functions", "Crashlyitics", "Messaging", "Remote Config", "Storage"],
    "Google": ["AdMob", "Analytics"],
    "Naver": ["Naver Map"],
    "Flutter": ["Provider"],
  },
  "jjgsr": {
    "UI": ["Figma",],
    "Communication": ["Confluence"],
    "Database": ["Firebase Firestore",],
    "Firebase": ["Authentication", "App Check", "Crashlyitics", "Firestore", "Remote Config"],
    "Google": ["AdMob", "Analytics"],
    "Flutter": ["Provider"],
  },
};

const Map<String, Map<String, List<String>>> kSelfIntroductionEnList = {
  "Experience" : {
    "Company": ["AD Intelligence", "Maeil Daires", "App Developing"],
    "Duration": ["2021.08 ~ 2022.02", "2022.07 ~ 2022.12", "2023.02 ~"],
    "Performance" : [
      "⦁ Managed Facebook and Zigzag advertising accounts and campaigns\n⦁ Planned performance dashboard within our advertising solution",
      "⦁ Analyzed sales and quantity data by channel\n⦁ Planned and managed live broadcasts\n⦁ Supported on-site operations for Amazing Oat pop-up store",
      "⦁ Released 5 apps on the App Store\n⦁ Released 2 apps on the Play Store"
]
  },
  "Skill & Interested Topics" : {
    "Skill": ["⦁ Brand Marketing", "⦁ Cross-Platform App Development", "⦁ Data Analysis", "⦁ iOS App Development", "⦁ Performance Marketing", ],
    "Interested Topics": ["⦁ Development", "⦁ Marketing", "⦁ O2O Business", "⦁ Platform Business", "⦁ UI/UX", "⦁ Sports"]
  },
  "Education" : {
    "School": ["Inha University, Incheon, Republic of Korea"],
    "Major": ["Business Administration, Bachelor`s Degree"],
    "Duration": ["2015.03 ~ 2022.02"],
  },
};

const Map<String, Map<String, List<String>>> kSelfIntroductionKrList = {
  "이력": {
    "회사": ["AD Intelligence", "매일유업", "앱 개발 중"],
    "재직 기간": ["2021.08 ~ 2022.02", "2022.07 ~ 2022.12", "2023.02 ~"],
    "주요 성과" : [
      "⦁ 페이스북, 지그재그 광고 계정 및 캠페인 운영\n⦁ 자체 광고 솔루션 내 성과 대시보드 기획",
      "⦁ 채널별 판매량/수주량 데이터 분석\n⦁ 라이브방송 기획 및 성과 관리\n⦁ 어메이징오트 팝업스토어 현장 운영지원",
      "⦁ 앱스토어에 5개 출시 완료\n⦁ 플레이스토어에 2개 출시 완료"
    ]
  },
  "스킬 & 관심 주제": {
    "스킬": [
      "⦁ 브랜드 마케팅",
      "⦁ 크로스 플랫폼 앱 개발",
      "⦁ 데이터 분석",
      "⦁ iOS 앱 개발",
      "⦁ 퍼포먼스 마케팅",
    ],
    "관심 주제": [
      "⦁ 개발",
      "⦁ 마케팅",
      "⦁ O2O 비즈니스",
      "⦁ 플랫폼",
      "⦁ UI/UX",
      "⦁ 스포츠",
    ],
  },
  "학력": {
    "학교": ["인하대학교, 인천"],
    "전공": ["경영학과, 학사"],
    "기간": ["2015.03 ~ 2022.02"],
  },
};
