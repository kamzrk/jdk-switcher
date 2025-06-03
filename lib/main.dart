import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(JavaVersionSwitcherApp());
}

class JavaVersionSwitcherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Java Version Switcher',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: JavaVersionSwitcher(),
    );
  }
}

class JavaVersionSwitcher extends StatefulWidget {
  @override
  _JavaVersionSwitcherState createState() => _JavaVersionSwitcherState();
}

class _JavaVersionSwitcherState extends State<JavaVersionSwitcher> {
  String? _selectedVersion;

  final Map<String, String> javaPaths = {
    'Java 8': r'C:\Program Files\Java\jdk1.8.0_321',
    'Java 11': r'C:\Program Files\Java\jdk-11.0.10',
    'Java 17': r'C:\Program Files\Java\jdk-17',
  };

  void _setJavaVersion() {
    if (_selectedVersion != null) {
      final selectedPath = javaPaths[_selectedVersion]!;
      // Set JAVA_HOME only for current process (simulation)
      Process.run('setx', ['JAVA_HOME', selectedPath], runInShell: true).then((result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('JAVA_HOME set to $_selectedVersion')),
        );
      });
    }
  }

  void _cancel() {
    setState(() {
      _selectedVersion = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Java Version Switcher')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedVersion,
              decoration: InputDecoration(labelText: 'Select Java Version'),
              items: javaPaths.keys
                  .map((version) => DropdownMenuItem(
                        value: version,
                        child: Text(version),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedVersion = value),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: _cancel, child: Text('Cancel')),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _selectedVersion != null ? _setJavaVersion : null,
                  child: Text('OK'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
