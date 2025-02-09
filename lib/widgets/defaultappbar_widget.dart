import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;
  final bool showTransparent;
  final bool automaticallyImplyLeading;

  const DefaultAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLeading = true,
    this.showTransparent = false,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: showTransparent ? Colors.transparent : Theme.of(context).colorScheme.primary,
      elevation: showTransparent ? 0 : 5,
      automaticallyImplyLeading: automaticallyImplyLeading,
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
