import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;

  const DefaultAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
              ),
            ),
        ],
      ),
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
