import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this._ref, ProviderListenable<dynamic> listenable) {
    // listen ke perubahan provider authSession, tiap berubah -> notify router
    _remove = _ref
        .listen<dynamic>(
          // nanti kita set dari app_router dengan provider spesifik
          listenable,
          (_, __) => notifyListeners(),
        )
        .close;
  }

  final Ref _ref;
  late final void Function() _remove;

  @override
  void dispose() {
    _remove();
    super.dispose();
  }
}
