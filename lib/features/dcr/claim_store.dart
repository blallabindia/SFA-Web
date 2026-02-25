import 'claim_model.dart';

class ClaimStore {
  ClaimStore._private();
  static final ClaimStore _instance = ClaimStore._private();
  factory ClaimStore() => _instance;

  final List<Claim> _claims = [];

  List<Claim> get all => List.unmodifiable(_claims);

  void addClaim(Claim c) {
    _claims.add(c);
  }

  void updateClaim(Claim c) {
    final idx = _claims.indexWhere((x) => x.id == c.id);
    if (idx >= 0) _claims[idx] = c;
  }

  List<Claim> claimsForVisit(String visitId) => _claims.where((c) => c.visitIds.contains(visitId)).toList();

  bool isVisitInSubmittedClaim(String visitId) {
    return _claims.any((c) => c.visitIds.contains(visitId) && c.status == ClaimStatus.submitted);
  }

  void setStatus(String claimId, ClaimStatus status, {String? remarks}) {
    final idx = _claims.indexWhere((c) => c.id == claimId);
    if (idx >= 0) {
      final c = _claims[idx];
      final updated = Claim(
        id: c.id,
        salesPerson: c.salesPerson,
        visitIds: c.visitIds,
        expenses: c.expenses,
        status: status,
        createdAt: c.createdAt,
        managerRemarks: remarks ?? c.managerRemarks,
      );
      _claims[idx] = updated;
    }
  }
}
