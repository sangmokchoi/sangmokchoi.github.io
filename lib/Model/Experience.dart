class Experience {
  final List<String>? companies;
  final List<String>? durations;
  final List<String>? performances;

  Experience({this.companies, this.durations, this.performances});

  List<String>? getCompanies(Map<String, List<String>> details) {
    return details['Company'] ?? details['회사'];
  }

  List<String>? getDurations(Map<String, List<String>> details) {
    return details['Duration'] ?? details['재직 기간'];
  }

  List<String>? getPerformances(Map<String, List<String>> details) {
    return details['Performance'] ?? details['주요 성과'];
  }
}