import 'package:flutter/material.dart';

Widget buildTextField({
  String? hint,
  IconData? icon,
  TextEditingController? ctrl,
  TextInputType? inputType,
  bool obscure = false,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30),
    child: Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            SizedBox(width: 15),
            Icon(icon),
            SizedBox(width: 10),
            Flexible(
              child: TextField(
                obscureText: obscure,
                controller: ctrl,
                keyboardType: inputType,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint ?? '',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
