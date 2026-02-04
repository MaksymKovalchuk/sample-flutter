import 'dart:async';
import 'package:sample/src/core/caches/preferences.dart';
import 'package:sample/src/core/navigation/core/navigation_service.dart';
import 'package:sample/src/core/network/core/rest_client.dart';
import 'package:sample/src/core/network/errors/app_exception.dart';
import 'package:sample/src/core/network/token/token_provider.dart';
import 'package:sample/src/core/session/account_manager.dart';
import 'package:sample/src/core/session/token_guard.dart';
import 'package:sample/src/feature/widgets/app_snack_bar.dart';
import 'package:sample/src/services/logging/logger.dart';

class LogoutManager {
  LogoutManager({
    required this.prefs,
    required this.tokenProvider,
    required this.restClient,
    required this.accountManager,
    required void Function() onLoggedOut,
  }) : _onLoggedOut = onLoggedOut;

  final Preferences prefs;
  final TokenProvider tokenProvider;
  final RestClient restClient;
  final AccountManager accountManager;
  final void Function() _onLoggedOut;

  Completer<void>? _logoutCompleter;
  Completer<void>? _clearDataCompleter;

  bool get isLoggingOut => _logoutCompleter != null;

  /// Ensures logout logic runs only once, even if triggered multiple times.
  Future<void> logout({String? message, String source = 'unknown'}) async {
    if (_logoutCompleter != null) return _logoutCompleter!.future;

    _logoutCompleter = Completer<void>();
    logger.warning("LogoutManager triggered from [$source]: ${message ?? ''}");

    if (message != null && message.isNotEmpty && globalContext != null) {
      SnackBarManager().show(globalContext!, message: message);
    }

    try {
      await clearData(); // clears all local and remote session state
      _onLoggedOut(); // notifies AppBloc or equivalent handler
      _logoutCompleter?.complete();
    } catch (e, stack) {
      logger.error("Logout process failed", error: e, stackTrace: stack);
      _logoutCompleter?.completeError(e, stack);
    } finally {
      _logoutCompleter = null;
    }
  }

  /// Clears local session, calls remote logout once, skips if already done.
  Future<void> clearData() {
    if (_clearDataCompleter != null) return _clearDataCompleter!.future;

    _clearDataCompleter = Completer<void>();

    return _clearDataInternal().then((_) {
      _clearDataCompleter?.complete();
    }).catchError((e, stack) {
      _clearDataCompleter?.completeError(e, stack);
    });
  }

  Future<void> _clearDataInternal() async {
    if (TokenGuard.tokenRecoveryFailed) {
      logger.info("TokenGuard active — performing local clear only");
      await _clearCache();
      return;
    }

    logger.info("LogoutManager: clearing local + remote session data");

    await _safeLogoutRemote();
    await _clearCache();
  }

  Future<void> _clearCache() async {
    try {
      await prefs.clearCache(); // clears stored data
      accountManager.clear();
    } catch (e) {
      logger.error("clearCache failed", error: e);
    }
  }

  /// Sends logout request to backend if token is valid or refreshable.
  Future<void> _safeLogoutRemote() async {
    try {
      final isExpired = await tokenProvider.isTokenExpired();
      if (isExpired) {
        logger.info("Token expired, attempting refresh before logout...");
        try {
          await tokenProvider.getValidAccessToken(); // try refresh
        } on SessionExpiredException {
          logger.warning("Refresh token invalid, skipping logout request.");
          return;
        }
      }

      // await restClient.request<void>(
      //   bypassInitializer: true,
      //   apiModel: ApiModel(
      //     serviceType: ServiceType.portal,
      //     method: Method.delete,
      //     pathUrl: Requests.sessions,
      //   ),
      // );
    } catch (e, stack) {
      logger.error("Logout REST call failed (ignored once)",
          error: e, stackTrace: stack);
    }
  }

  /// Resets internal flags to allow next logout.
  void reset() {
    _logoutCompleter = null;
    _clearDataCompleter = null;
  }
}
