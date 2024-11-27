import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget{
  final String title;

  @override
  //TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppbarWidget(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
}