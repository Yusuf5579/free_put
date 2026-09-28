import 'package:flutter/material.dart';
import 'package:free_put/src/core/widgets/pill_tabs.dart';

class TypeButton extends StatefulWidget {
  const TypeButton({super.key});

  @override
  State<TypeButton> createState() => _TypeButtonState();
}

class _TypeButtonState extends State<TypeButton> {
  static const _sections = ['All', 'Documents', 'Images', 'Videos'];
  int _currentSection = 0;

  @override
  Widget build(BuildContext context) {
    return PillTabs(
      labels: _sections,
      selectedIndex: _currentSection,
      onSelected: (index) => setState(() => _currentSection = index),
    );
  }
}
