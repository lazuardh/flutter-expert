import 'dart:io';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  /* kondisi untuk json yang tidak terbaca di package core */
  if (dir.endsWith('core')) {
    return File('$dir/test/$name').readAsStringSync();
  }
  return File('$dir/core/test/$name').readAsStringSync();
  // return File('$dir/test/$name').readAsStringSync();
}
