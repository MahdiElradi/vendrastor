import 'package:flutter_test/flutter_test.dart';

import 'package:vendrastor_app/core/config/app_constants.dart';

void main() {
  test('app name is VendraStor', () {
    expect(AppConstants.appName, 'VendraStor');
  });
}
