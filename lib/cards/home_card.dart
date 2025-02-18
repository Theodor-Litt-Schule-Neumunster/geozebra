import 'package:flutter/material.dart';

class ScreenCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ScreenCard({
    Key? key,
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
