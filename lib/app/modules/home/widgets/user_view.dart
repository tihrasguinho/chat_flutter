import 'package:chat/app/shared/functions/get_empty_image_url.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  const UserView({
    Key? key,
    required this.item,
    this.onPressed,
  }) : super(key: key);

  final UserModel item;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () => onPressed!(),
          borderRadius: BorderRadius.circular(4),
          splashColor: Colors.black12,
          highlightColor: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    item.image!.isEmpty
                        ? getEmptyImageUrl(item.name!.replaceAll(' ', '+'))
                        : item.image!,
                  ),
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      item.email!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
