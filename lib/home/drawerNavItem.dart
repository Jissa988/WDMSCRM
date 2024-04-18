
import 'package:flutter/material.dart';

import '../config/themes.dart';

class DrawerNavItem extends StatelessWidget {
  final VoidCallback callback;
  final IconData iconData;
  final String navItemTitle;
  final ThemeData theme;
  final String imagePath;

  const DrawerNavItem({
    required this.callback,
    required this.iconData,
    required this.navItemTitle,
    required this.theme,
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: callback,
       leading:  Image.asset(imagePath,
           width: 30, height: 30, color: AppColors.lightGray),
       trailing: Icon(iconData,
            size: 20
       ),
      title: Text(
        navItemTitle,
        style: theme.textTheme.headline3,
      ),
    );
  }
}