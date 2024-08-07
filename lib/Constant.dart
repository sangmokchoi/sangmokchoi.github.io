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
      "UI": ["UIkit", "Storyboard", "(Widget) SwiftUI"],
      "Communication": ["Confluence", "Jira"],
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
    "Firebase": ["Authentication", "App Check", "Crashlyitics", "Cloud Functions", "Messaging", "Remote Config", "Storage"],
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

