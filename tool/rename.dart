// Rename the entire starter template (Dart package, Android, iOS, bundle IDs).
//
// Usage:
//   dart run tool/rename.dart --name my_shop --bundle-id com.company.myshop
//   dart run tool/rename.dart --name my_shop --bundle-id com.company.myshop --title "My Shop"
//   dart run tool/rename.dart --name my_shop --bundle-id com.company.myshop --dry-run
//   dart run tool/rename.dart --name my_shop --bundle-id com.company.myshop --force
//
// By default the script refuses to run on a dirty git tree. Use `--force` to
// bypass (not recommended). A `--dry-run` is strongly encouraged first.
//
// The script keeps the entire folder structure, architecture, dependencies
// and generated files intact. It only replaces identifiers.

import 'dart:io';

import 'package:args/args.dart';

void main(List<String> rawArgs) async {
  final parser = _buildParser();
  final ArgResults args;
  try {
    args = parser.parse(rawArgs);
  } on FormatException catch (e) {
    stderr.writeln('❌ ${e.message}\n');
    _printUsage(parser);
    exit(64);
  }

  if (args['help'] as bool) {
    _printUsage(parser);
    return;
  }

  final config = _RenameConfig.fromArgs(args);

  try {
    config.validate();
  } on FormatException catch (e) {
    stderr.writeln('❌ ${e.message}\n');
    _printUsage(parser);
    exit(64);
  }

  if (!config.force && !config.dryRun) {
    _ensureCleanGit();
  }

  final current = _Current.detect();
  final plan = _Plan.build(current: current, config: config);

  plan.print(dryRun: config.dryRun);

  if (config.dryRun) {
    stdout.writeln('\nDry-run only. Re-run without --dry-run to apply.');
    return;
  }

  if (!config.force) {
    stdout.write('\nProceed with the rename? [y/N] ');
    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    if (input != 'y' && input != 'yes') {
      stdout.writeln('Aborted.');
      return;
    }
  }

  plan.apply();

  stdout.writeln('\n▶ Running post-rename steps...');
  _runPostActions();

  stdout.writeln('\n✅ Done. Try:');
  stdout.writeln('   flutter run');
}

// ---------------------------------------------------------------------------
// CLI parsing
// ---------------------------------------------------------------------------

ArgParser _buildParser() => ArgParser()
  ..addOption(
    'name',
    abbr: 'n',
    help: 'New Dart package name (snake_case, e.g. my_shop).',
  )
  ..addOption(
    'bundle-id',
    abbr: 'b',
    help: 'New bundle identifier (e.g. com.company.myshop).',
  )
  ..addOption(
    'title',
    abbr: 't',
    help: 'Human-readable app title. Defaults to Title Case of --name.',
  )
  ..addFlag(
    'dry-run',
    negatable: false,
    help: 'Show planned changes without applying them.',
  )
  ..addFlag(
    'force',
    negatable: false,
    help: 'Skip git-clean check and skip confirmation.',
  )
  ..addFlag('help', abbr: 'h', negatable: false, help: 'Print usage.');

void _printUsage(ArgParser parser) {
  stdout.writeln('Rename this Flutter starter to a new project name.\n');
  stdout.writeln(
    'Example:\n'
    '  dart run tool/rename.dart \\\n'
    '    --name my_shop \\\n'
    '    --bundle-id com.company.myshop \\\n'
    '    --title "My Shop"\n',
  );
  stdout.writeln('Options:\n${parser.usage}');
}

// ---------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------

class _RenameConfig {
  _RenameConfig({
    required this.newName,
    required this.newBundleId,
    required this.newTitle,
    required this.dryRun,
    required this.force,
  });

  factory _RenameConfig.fromArgs(ArgResults args) {
    final name = (args['name'] as String?)?.trim() ?? '';
    final bundleId = (args['bundle-id'] as String?)?.trim() ?? '';
    final rawTitle = (args['title'] as String?)?.trim();
    final title = (rawTitle == null || rawTitle.isEmpty)
        ? _titleCase(name)
        : rawTitle;
    return _RenameConfig(
      newName: name,
      newBundleId: bundleId,
      newTitle: title,
      dryRun: args['dry-run'] as bool,
      force: args['force'] as bool,
    );
  }

  final String newName;
  final String newBundleId;
  final String newTitle;
  final bool dryRun;
  final bool force;

  static final _nameRegex = RegExp(r'^[a-z][a-z0-9_]*$');
  static final _bundleRegex = RegExp(
    r'^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$',
  );
  static const _reserved = {'dart', 'flutter', 'test', 'async', 'core', 'main'};

  void validate() {
    if (newName.isEmpty) {
      throw const FormatException('--name is required.');
    }
    if (!_nameRegex.hasMatch(newName)) {
      throw FormatException(
        '--name "$newName" is not a valid Dart package name '
        '(must match ${_nameRegex.pattern}).',
      );
    }
    if (_reserved.contains(newName)) {
      throw FormatException('--name "$newName" is reserved; pick another.');
    }
    if (newBundleId.isEmpty) {
      throw const FormatException('--bundle-id is required.');
    }
    if (!_bundleRegex.hasMatch(newBundleId)) {
      throw FormatException(
        '--bundle-id "$newBundleId" is not valid '
        '(expected 2+ dot-separated identifiers, e.g. com.company.app).',
      );
    }
  }
}

String _titleCase(String snake) => snake
    .split('_')
    .where((p) => p.isNotEmpty)
    .map((p) => p[0].toUpperCase() + p.substring(1))
    .join(' ');

// ---------------------------------------------------------------------------
// Detect current values
// ---------------------------------------------------------------------------

class _Current {
  _Current({
    required this.dartName,
    required this.androidBundleId,
    required this.iosBundleId,
    required this.androidLabel,
    required this.kotlinDir,
  });

  final String dartName;
  final String androidBundleId;
  final String iosBundleId;
  final String androidLabel;
  final Directory kotlinDir;

  static _Current detect() {
    final dartName = _readPubspecName();
    final androidBundleId = _readAndroidAppId();
    final iosBundleId = _readIosBundleId();
    final androidLabel = _readAndroidLabel();
    final kotlinDir = _findKotlinDir();
    return _Current(
      dartName: dartName,
      androidBundleId: androidBundleId,
      iosBundleId: iosBundleId,
      androidLabel: androidLabel,
      kotlinDir: kotlinDir,
    );
  }

  static String _readPubspecName() {
    final file = File('pubspec.yaml');
    final match = RegExp(
      r'^name:\s*(\S+)\s*$',
      multiLine: true,
    ).firstMatch(file.readAsStringSync());
    if (match == null) {
      throw StateError('Could not read name: from pubspec.yaml');
    }
    return match.group(1)!;
  }

  static String _readAndroidAppId() {
    final file = File('android/app/build.gradle.kts');
    final content = file.readAsStringSync();
    final match = RegExp(r'applicationId\s*=\s*"([^"]+)"').firstMatch(content);
    if (match == null) {
      throw StateError('Could not read applicationId from build.gradle.kts');
    }
    return match.group(1)!;
  }

  static String _readIosBundleId() {
    final file = File('ios/Runner.xcodeproj/project.pbxproj');
    final content = file.readAsStringSync();
    // Take the FIRST non-test bundle ID as the base (.RunnerTests is a variant)
    final match = RegExp(
      r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*([a-zA-Z][\w.]*)\s*;',
    ).firstMatch(content);
    if (match == null) {
      throw StateError(
        'Could not read PRODUCT_BUNDLE_IDENTIFIER from iOS project.',
      );
    }
    final raw = match.group(1)!;
    // Strip .RunnerTests if it matched that variant first (unlikely but safe)
    return raw.endsWith('.RunnerTests')
        ? raw.substring(0, raw.length - '.RunnerTests'.length)
        : raw;
  }

  static String _readAndroidLabel() {
    final file = File('android/app/src/main/AndroidManifest.xml');
    final content = file.readAsStringSync();
    final match = RegExp(r'android:label\s*=\s*"([^"]+)"').firstMatch(content);
    return match?.group(1) ?? '';
  }

  static Directory _findKotlinDir() {
    final root = Directory('android/app/src/main/kotlin');
    if (!root.existsSync()) {
      throw StateError('No android/app/src/main/kotlin directory found.');
    }
    final mainActivity = root
        .listSync(recursive: true)
        .whereType<File>()
        .firstWhere(
          (f) => f.path.endsWith('/MainActivity.kt'),
          orElse: () =>
              throw StateError('MainActivity.kt not found under $root.'),
        );
    return mainActivity.parent;
  }
}

// ---------------------------------------------------------------------------
// Plan — collects every change before applying so --dry-run shows exact diff
// ---------------------------------------------------------------------------

class _Plan {
  _Plan._(this._steps);

  final List<_Step> _steps;

  static _Plan build({
    required _Current current,
    required _RenameConfig config,
  }) {
    final steps = <_Step>[];

    // 1. pubspec.yaml
    steps.add(
      _Step(
        summary: 'pubspec.yaml → name: ${config.newName}',
        action: () => _replaceInFile(
          File('pubspec.yaml'),
          RegExp(r'^name:\s*\S+\s*$', multiLine: true),
          'name: ${config.newName}',
        ),
      ),
    );

    // 2. Dart imports (lib/ + test/)
    final dartFiles = [
      ...Directory('lib').listSync(recursive: true).whereType<File>(),
      if (Directory('test').existsSync())
        ...Directory('test').listSync(recursive: true).whereType<File>(),
    ].where((f) => f.path.endsWith('.dart')).toList();

    steps.add(
      _Step(
        summary:
            'Dart imports in ${dartFiles.length} files: '
            'package:${current.dartName}/ → package:${config.newName}/',
        action: () {
          for (final file in dartFiles) {
            final content = file.readAsStringSync();
            final updated = content.replaceAll(
              'package:${current.dartName}/',
              'package:${config.newName}/',
            );
            if (updated != content) file.writeAsStringSync(updated);
          }
        },
      ),
    );

    // 3. Android: build.gradle.kts — namespace + applicationId
    steps.add(
      _Step(
        summary:
            'android/app/build.gradle.kts: '
            '${current.androidBundleId} → ${config.newBundleId}',
        action: () => _replaceInFile(
          File('android/app/build.gradle.kts'),
          current.androidBundleId,
          config.newBundleId,
          replaceAll: true,
        ),
      ),
    );

    // 4. Android: AndroidManifest.xml label
    if (current.androidLabel.isNotEmpty) {
      steps.add(
        _Step(
          summary:
              'AndroidManifest label: '
              '"${current.androidLabel}" → "${config.newTitle}"',
          action: () => _replaceInFile(
            File('android/app/src/main/AndroidManifest.xml'),
            'android:label="${current.androidLabel}"',
            'android:label="${config.newTitle}"',
          ),
        ),
      );
    }

    // 5. Android: move Kotlin folder + update package declaration
    final kotlinRoot = Directory('android/app/src/main/kotlin');
    final currentPkgPath = current.kotlinDir.path.substring(
      kotlinRoot.path.length + 1,
    ); // com/example/sample_application
    final newPkgPath = config.newBundleId.replaceAll('.', '/');
    final newKotlinDir = Directory('${kotlinRoot.path}/$newPkgPath');
    final currentPkg = currentPkgPath.replaceAll('/', '.');
    final newPkg = config.newBundleId;

    if (currentPkgPath != newPkgPath) {
      steps.add(
        _Step(
          summary:
              'Kotlin folder: $currentPkgPath → $newPkgPath (+ update package)',
          action: () {
            // Create new dir, move files, update package line, remove empty dirs.
            newKotlinDir.createSync(recursive: true);
            for (final file in current.kotlinDir.listSync().whereType<File>()) {
              final name = file.uri.pathSegments.last;
              final target = File('${newKotlinDir.path}/$name');
              var content = file.readAsStringSync();
              content = content.replaceAll(
                'package $currentPkg',
                'package $newPkg',
              );
              target.writeAsStringSync(content);
              file.deleteSync();
            }
            _pruneEmpty(current.kotlinDir, stopAt: kotlinRoot);
          },
        ),
      );
    }

    // 6. iOS: project.pbxproj bundle ID (all variants incl. .RunnerTests)
    steps.add(
      _Step(
        summary:
            'iOS PRODUCT_BUNDLE_IDENTIFIER: '
            '${current.iosBundleId} → ${config.newBundleId}',
        action: () => _replaceInFile(
          File('ios/Runner.xcodeproj/project.pbxproj'),
          current.iosBundleId,
          config.newBundleId,
          replaceAll: true,
        ),
      ),
    );

    // 7. iOS: Info.plist — CFBundleName + CFBundleDisplayName
    steps.add(
      _Step(
        summary:
            'iOS Info.plist CFBundleName → ${config.newName}, '
            'CFBundleDisplayName → "${config.newTitle}"',
        action: () {
          final file = File('ios/Runner/Info.plist');
          var content = file.readAsStringSync();
          content = _replacePlistKey(content, 'CFBundleName', config.newName);
          content = _replacePlistKey(
            content,
            'CFBundleDisplayName',
            config.newTitle,
          );
          file.writeAsStringSync(content);
        },
      ),
    );

    // 8. IntelliJ .iml rename (cosmetic — optional)
    final oldIml = File('${current.dartName}.iml');
    final altIml = File('sample_application.iml'); // common default
    final imlToRename = oldIml.existsSync()
        ? oldIml
        : (altIml.existsSync() ? altIml : null);
    if (imlToRename != null) {
      final newIml = File('${config.newName}.iml');
      steps.add(
        _Step(
          summary:
              'Rename ${imlToRename.uri.pathSegments.last} → ${newIml.uri.pathSegments.last}',
          action: () => imlToRename.renameSync(newIml.path),
        ),
      );
    }

    return _Plan._(steps);
  }

  void print({required bool dryRun}) {
    stdout.writeln(dryRun ? '── DRY RUN ──' : '── Planned changes ──');
    for (var i = 0; i < _steps.length; i++) {
      stdout.writeln('${i + 1}. ${_steps[i].summary}');
    }
  }

  void apply() {
    for (final step in _steps) {
      stdout.writeln('• ${step.summary}');
      step.action();
    }
  }
}

class _Step {
  _Step({required this.summary, required this.action});
  final String summary;
  final void Function() action;
}

// ---------------------------------------------------------------------------
// File helpers
// ---------------------------------------------------------------------------

void _replaceInFile(
  File file,
  Pattern match,
  String replacement, {
  bool replaceAll = false,
}) {
  final content = file.readAsStringSync();
  final updated = replaceAll
      ? content.replaceAll(match, replacement)
      : content.replaceFirst(match, replacement);
  if (updated != content) file.writeAsStringSync(updated);
}

String _replacePlistKey(String content, String key, String newValue) {
  final pattern = RegExp(
    '<key>${RegExp.escape(key)}</key>\\s*<string>([^<]*)</string>',
  );
  return content.replaceFirstMapped(
    pattern,
    (_) => '<key>$key</key>\n\t<string>$newValue</string>',
  );
}

void _pruneEmpty(Directory start, {required Directory stopAt}) {
  var dir = start;
  while (dir.path != stopAt.path &&
      dir.existsSync() &&
      dir.listSync().isEmpty) {
    final parent = dir.parent;
    dir.deleteSync();
    dir = parent;
  }
}

// ---------------------------------------------------------------------------
// Safety checks
// ---------------------------------------------------------------------------

void _ensureCleanGit() {
  final result = Process.runSync('git', ['status', '--porcelain']);
  if (result.exitCode != 0) {
    stderr.writeln('⚠ Could not run `git status`. Skipping clean-tree check.');
    return;
  }
  final out = (result.stdout as String).trim();
  if (out.isNotEmpty) {
    stderr.writeln(
      '❌ Working tree is not clean. Commit or stash changes first, '
      'or pass --force (not recommended).\n\n$out',
    );
    exit(1);
  }
}

// ---------------------------------------------------------------------------
// Post-rename actions
// ---------------------------------------------------------------------------

void _runPostActions() {
  _run('flutter', ['pub', 'get']);
  _run('dart', [
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);
  // Re-sort directives (import order can shift after the package rename) and
  // format files touched by the sed-style replacements.
  _run('dart', ['fix', '--apply']);
  _run('dart', ['format', '.']);
}

void _run(String cmd, List<String> args) {
  stdout.writeln('  \$ $cmd ${args.join(' ')}');
  final result = Process.runSync(cmd, args, runInShell: true);
  if (result.exitCode != 0) {
    stderr.writeln(result.stdout);
    stderr.writeln(result.stderr);
    stderr.writeln('⚠ $cmd exited with code ${result.exitCode}');
  }
}
