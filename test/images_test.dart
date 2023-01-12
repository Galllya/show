import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:slow/resources/resources.dart';

void main() {
  test('images assets test', () {
    expect(File(Images.bgPattern).existsSync(), true);
    expect(File(Images.dialogPart).existsSync(), true);
    expect(File(Images.logo).existsSync(), true);
  });
}
