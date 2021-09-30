import 'package:calunedar/calunedar.dart';
import 'package:calunedar/extra_licenses.dart';
import 'package:calunedar/redux/models.dart';
import 'package:calunedar/redux/reducer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(extraLicenses);

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(
      key: 'calunedar',
      location: kIsWeb
          ? FlutterSaveLocation.sharedPreferences
          : FlutterSaveLocation.documentFile,
    ),
    serializer: JsonSerializer<AppState>(AppState.fromJson)
  );

  final initialState = await persistor.load();

  final store = Store<AppState>(
    reducer,
    initialState: initialState ?? AppState(),
    middleware: [
      thunkMiddleware,
      persistor.createMiddleware(),
      LoggingMiddleware.printer(),
    ],
  );

  runApp(_Root(store: store));
}

class _Root extends StatelessWidget {
  const _Root({Key? key, required this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Calunedar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          backgroundColor: Colors.white,
        ),
        home: const Calunedar(),
      ),
    );
  }
}
