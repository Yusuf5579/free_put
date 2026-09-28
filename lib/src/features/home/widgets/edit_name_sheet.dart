import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Bottom sheet with a single text field for renaming a file.
class EditNameSheet extends StatelessWidget {
  const EditNameSheet({
    super.key,
    required this.controller,
    required this.loading,
    required this.onUpdate,
  });

  final TextEditingController controller;
  final bool loading;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const .symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            const _DragHandle(),
            const SizedBox(height: 24),
            const Text(
              'Edit Name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: .bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Fill the field and tap update button',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            _NameField(controller: controller),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: loading
                    ? const CupertinoActivityIndicator(color: Colors.white)
                    : const Text(
                        'Update',
                        style: TextStyle(fontSize: 16, fontWeight: .w600),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: 'New name',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFFAFAFAF).withValues(alpha: 0.08),
        contentPadding: const .symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: Color(0xFF2D3142), width: 1.5),
        ),
      ),
    );
  }
}
