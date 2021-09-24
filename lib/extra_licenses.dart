import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Stream<LicenseEntry> extraLicenses() async* {
  var mitLicense = await rootBundle.loadString('license_texts/mit.txt');

  yield LicenseEntryWithLineBreaks(
    ['meeus'],
    'MIT License\n\nCopyright (c) 2020 Shawn Lauzon\n\nCopyright (c) 2018 Sonia Keys\n\nhttps://github.com/shawnlauzon/meeus\n\n$mitLicense',
  );

  var gplLicense = await rootBundle.loadString('license_texts/gplv3.txt');

  yield LicenseEntryWithLineBreaks(
    ['heniautos'],
    'https://github.com/seanredmond/heniautos\n\n$gplLicense',
  );
}
