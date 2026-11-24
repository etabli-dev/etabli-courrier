import '../../l10n/l10n.dart';
import 'net_error.dart';

extension NetErrorText on AppLocalizations {
  /// A short description of [error] for the UI; [NetError.message] stays
  /// English for logs.
  String netError(NetError error) => switch (error) {
    OfflineError() => netErrorOffline,
    UnauthorizedError() => netErrorUnauthorized,
    ForbiddenError() => netErrorForbidden,
    NotFoundError() => netErrorNotFound,
    PreconditionFailedError() => netErrorPrecondition,
    ConflictError() => netErrorConflict,
    ThrottledError() => netErrorThrottled,
    ServerError() => netErrorServer,
    ParseFailureError(:final detail) => netErrorParse(detail),
    UnknownNetError() => netErrorUnknown,
  };
}
