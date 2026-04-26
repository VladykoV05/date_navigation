enum ProposalResponseDecision { accept, reject }

enum MeetingRevoteResponseDecision { accept, reject }

enum ProposalAuthorRole { creator, partner }

extension ProposalResponseDecisionX on ProposalResponseDecision {
  bool get isAccepted => this == ProposalResponseDecision.accept;
}

extension MeetingRevoteResponseDecisionX on MeetingRevoteResponseDecision {
  bool get isAccepted => this == MeetingRevoteResponseDecision.accept;
}

extension ProposalAuthorRoleX on ProposalAuthorRole {
  String get wireValue => switch (this) {
    ProposalAuthorRole.creator => 'creator',
    ProposalAuthorRole.partner => 'partner',
  };
}
