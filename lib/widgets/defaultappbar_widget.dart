import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;

  const DefaultAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 5,
      leading: showLeading
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}