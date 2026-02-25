import 'visit_model.dart';

class VisitStore {
  VisitStore._private();
  static final VisitStore _instance = VisitStore._private();
  factory VisitStore() => _instance;

  final List<Visit> visits = [];
  final List<Visit> completedVisits = [];

  void addVisit(Visit v) {
    visits.add(v);
  }

  void addVisits(List<Visit> vs) {
    visits.addAll(vs);
  }

  void markCompleted(String visitId) {
    try {
      final v = visits.firstWhere((x) => x.id == visitId);
      final exists = completedVisits.any((c) => c.id == v.id);
      if (!exists) completedVisits.add(v);
    } catch (_) {}
  }

  void clear() {
    visits.clear();
    completedVisits.clear();
  }
}
