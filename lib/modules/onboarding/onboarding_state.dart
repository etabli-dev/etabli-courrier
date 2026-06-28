import 'package:meta/meta.dart';

// Sealed state machine for the unified onboarding flow.
//   Welcome → Nextcloud → IMAP → M365 (optional) → Finished
//
// Each step exposes a result + (where applicable) a list of error messages
// the UI can render as actionable cards. Skipping is always allowed —
// the user can run onboarding piecemeal.

enum OnboardingStage { welcome, nextcloud, imap, microsoft365, finished }

@immutable
sealed class StepOutcome {
  const StepOutcome();
}

class StepNotRun extends StepOutcome {
  const StepNotRun();
}

class StepInProgress extends StepOutcome {
  const StepInProgress();
}

class StepSkipped extends StepOutcome {
  const StepSkipped();
}

class StepSucceeded extends StepOutcome {
  const StepSucceeded({
    required this.accountId,
    this.collectionIds = const <int>[],
    this.detail,
  });
  final int accountId;
  final List<int> collectionIds;
  final String? detail;
}

class StepFailed extends StepOutcome {
  const StepFailed({required this.message, this.detail});
  final String message;
  final String? detail;
}

@immutable
class OnboardingState {
  const OnboardingState({
    this.stage = OnboardingStage.welcome,
    this.nextcloud = const StepNotRun(),
    this.imap = const StepNotRun(),
    this.microsoft365 = const StepNotRun(),
  });

  final OnboardingStage stage;
  final StepOutcome nextcloud;
  final StepOutcome imap;
  final StepOutcome microsoft365;

  OnboardingState copyWith({
    OnboardingStage? stage,
    StepOutcome? nextcloud,
    StepOutcome? imap,
    StepOutcome? microsoft365,
  }) => OnboardingState(
    stage: stage ?? this.stage,
    nextcloud: nextcloud ?? this.nextcloud,
    imap: imap ?? this.imap,
    microsoft365: microsoft365 ?? this.microsoft365,
  );

  bool get hasAnySuccess =>
      nextcloud is StepSucceeded ||
      imap is StepSucceeded ||
      microsoft365 is StepSucceeded;
}
