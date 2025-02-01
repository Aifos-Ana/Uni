import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [
      Glob(r'test_driver/features/loggedOut/**.feature')
    ]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ]
    ..stepDefinitions = [
    ]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = false
    ..targetAppPath = 'test_driver/app.dart';
  return GherkinRunner().execute(config);
}