import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:slow/resources/resources.dart';

void main() {
  test('svgs assets test', () {
    expect(File(Svgs.menu).existsSync(), true);
  });
}
