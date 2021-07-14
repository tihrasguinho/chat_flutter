import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    Key? key,
    required this.context,
    required this.title,
    required this.onTap,
    this.backgroundColor,
  }) : super(key: key);

  final BuildContext context;
  final String? title;
  final Function? onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(4),
        color: backgroundColor ?? Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onTap!(),
          highlightColor: Colors.black12,
          splashColor: Colors.black12,
          child: SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
