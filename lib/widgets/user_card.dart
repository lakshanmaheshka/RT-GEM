import 'package:flutter/material.dart';
import 'package:rt_gem/widgets/widgets.dart';

class UserCard extends StatelessWidget {

  const UserCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(
              "DefaultUser",
              //user.name,
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
