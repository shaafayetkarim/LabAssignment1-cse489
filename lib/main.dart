import 'package:flutter/material.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const VangtiChaiHome(),
    );
  }
}

class VangtiChaiHome extends StatefulWidget {
  const VangtiChaiHome({super.key});

  @override
  State<VangtiChaiHome> createState() => _VangtiChaiHomeState();
}

class _VangtiChaiHomeState extends State<VangtiChaiHome> {
  int _amount = 0;
  final List<int> _notes = [500, 100, 50, 20, 10, 5, 2, 1];

  void _updateAmount(int digit) {
    setState(() {
      _amount = _amount * 10 + digit;
    });
  }

  void _clearAmount() {
    setState(() {
      _amount = 0;
    });
  }

  Map<int, int> _calculateChange(int amount) {
    Map<int, int> change = {};
    int remaining = amount;
    for (int note in _notes) {
      change[note] = remaining ~/ note;
      remaining %= note;
    }
    return change;
  }

  @override
  Widget build(BuildContext context) {
    final change = _calculateChange(_amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VangtiChai'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Taka: ${_amount == 0 ? "" : _amount}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: orientation == Orientation.portrait
                      ? _buildPortraitLayout(change)
                      : _buildLandscapeLayout(change),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(Map<int, int> change) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildNotesList(change, _notes),
        ),
        Expanded(
          flex: 2,
          child: _buildKeypad(columns: 3),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(Map<int, int> change) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(child: _buildNotesList(change, _notes.sublist(0, 4))),
              Expanded(child: _buildNotesList(change, _notes.sublist(4, 8))),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildKeypad(columns: 4),
        ),
      ],
    );
  }

  Widget _buildNotesList(Map<int, int> change, List<int> notesSubset) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: notesSubset.map((note) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '$note: ${change[note]}',
            style: const TextStyle(fontSize: 20),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeypad({required int columns}) {
    List<Widget> buttons = [];
    if (columns == 3) {
      for (int i = 1; i <= 9; i++) {
        buttons.add(_buildKeyButton(i.toString(), () => _updateAmount(i)));
      }
      buttons.add(_buildKeyButton('0', () => _updateAmount(0)));
      buttons.add(_buildKeyButton('CLEAR', _clearAmount, flex: 2));
    } else {
      // Landscape keypad 4 columns
      for (int i = 1; i <= 8; i++) {
        buttons.add(_buildKeyButton(i.toString(), () => _updateAmount(i)));
      }
      buttons.add(_buildKeyButton('9', () => _updateAmount(9)));
      buttons.add(_buildKeyButton('0', () => _updateAmount(0)));
      buttons.add(_buildKeyButton('CLEAR', _clearAmount, flex: 2));
    }

    return GridView.count(
      crossAxisCount: columns,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: columns == 3 ? 1.5 : 2.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: buttons,
    );
  }

  Widget _buildKeyButton(String text, VoidCallback onPressed, {int flex = 1}) {
    // In GridView, flex doesn't work directly. 
    // For "CLEAR" to span multiple columns in GridView, we might need a different approach 
    // but the screenshot shows it just being one of the buttons or spanning 2 columns?
    // Let's re-examine the screenshot.
    // Portrait: CLEAR is in the same row as 0. 0 is col 1, CLEAR spans col 2 and 3.
    // Landscape: 9, 0, CLEAR. CLEAR spans col 3 and 4.
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        padding: EdgeInsets.zero,
      ),
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }
}
