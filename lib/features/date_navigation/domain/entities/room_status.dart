enum SessionStatus {
  active('active'),
  completed('completed'),
  expired('expired');

  const SessionStatus(this.wireValue);

  final String wireValue;

  bool get isActive => this == SessionStatus.active;
  bool get isCompleted => this == SessionStatus.completed;
  bool get isExpired => this == SessionStatus.expired;
  bool get isClosed => isCompleted || isExpired;

  static SessionStatus fromWireValue(Object? value) {
    final normalized = value?.toString().trim().toLowerCase();
    return switch (normalized) {
      'completed' => SessionStatus.completed,
      'expired' => SessionStatus.expired,
      _ => SessionStatus.active,
    };
  }
}

enum ProposalStatus {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected');

  const ProposalStatus(this.wireValue);

  final String wireValue;

  bool get isPending => this == ProposalStatus.pending;

  static ProposalStatus? fromWireValue(Object? value) {
    final normalized = value?.toString().trim().toLowerCase();
    return switch (normalized) {
      'pending' => ProposalStatus.pending,
      'accepted' => ProposalStatus.accepted,
      'rejected' => ProposalStatus.rejected,
      _ => null,
    };
  }
}

enum RevoteRequestStatus {
  pending('pending');

  const RevoteRequestStatus(this.wireValue);

  final String wireValue;

  bool get isPending => this == RevoteRequestStatus.pending;

  static RevoteRequestStatus? fromWireValue(Object? value) {
    final normalized = value?.toString().trim().toLowerCase();
    return switch (normalized) {
      'pending' => RevoteRequestStatus.pending,
      _ => null,
    };
  }
}
