import 'dart:io';

void main(List<String> arguments) async {
  var result = await Process.run(
    'flutter',
    ['pub', 'global', 'run', 'peanut:peanut'],
    runInShell: true,
  );

  stdout.write(result.stdout);
  stderr.write(result.stderr);

  if (result.exitCode == 0) {
    result = await Process.run(
      'git',
      ['push', '-u', 'origin', 'gh-pages'],
      runInShell: true,
    );

    stdout.write(result.stdout);
    stderr.write(result.stderr);
  }
}
