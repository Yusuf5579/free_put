import 'package:flutter/material.dart';

/// Horizontal row of pill-shaped tabs; the selected one is filled black.
class PillTabs extends StatelessWidget {
  const PillTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: .horizontal,
        itemCount: labels.length,
        itemBuilder: (context, index) => _Pill(
          label: labels[index],
          selected: index == selectedIndex,
          onTap: () => onSelected(index),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        margin: .only(right: 10),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: selected ? Colors.black : Colors.white,
        ),
        padding: .symmetric(vertical: 6, horizontal: 15),
        alignment: .center,
        child: Text(
          label,
          style: TextStyle(color: selected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
