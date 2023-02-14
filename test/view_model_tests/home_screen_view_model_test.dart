import 'package:beacon/config/environment_config.dart';
import 'package:beacon/locator.dart';
import 'package:beacon/router.dart' as router;
import 'package:beacon/services/database_mutation_functions.dart';
import 'package:beacon/view_model/home_screen_view_model.dart';
import 'package:beacon/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/mockito.dart';

Widget createMainScreen() {
  return MaterialApp(
    navigatorKey: navigationService.navigatorKey,
    onGenerateRoute: router.generateRoute,
    home: MainScreen(),
  );
}

class MockGraphQLClient extends Mock implements GraphQLClient {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvironmentConfig.loadEnvVariables();

  setupLocator();
  // localNotif.initialize();
  await databaseFunctions.init();
  await hiveDb.init();

  DataBaseMutationFunctions remoteDataSource;
  MockGraphQLClient mockClient;

  setUp(() {
    mockClient = MockGraphQLClient();
    remoteDataSource = DataBaseMutationFunctions(client: mockClient);
  });

  final viewModel = locator.get<HomeViewModel>();
  group("Test for Home Screen View Model", () {
    testWidgets("Check if Home Screen shows up", (tester) async {
      await tester.pumpWidget(createMainScreen());
      await tester.pump();

      expect(find.byType(MainScreen), findsOneWidget);
    });
  });
}
