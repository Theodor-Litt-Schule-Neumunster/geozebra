import 'package:flutter/material.dart';

class ScreenCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ScreenCard({
    super.key,
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: Theme.of(context).cardTheme.shape,
      child: ListTile(
        leading: Icon(
          iconData,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
