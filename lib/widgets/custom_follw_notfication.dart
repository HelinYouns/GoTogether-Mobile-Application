import 'package:flutter/material.dart';
import 'package:researchproject/constans/colors.dart';
import 'package:researchproject/widgets/custom_button.dart';

class CustomFollowNotfication extends StatefulWidget {
  const CustomFollowNotfication({Key? key}) : super(key: key);

  @override
  State<CustomFollowNotfication> createState() =>
      _CustomFollowNotficationState();
}

class _CustomFollowNotficationState extends State<CustomFollowNotfication> {
  bool follow = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("asset/user_.png"),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Maria Othman",
              style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: mainText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold), // Placeholder color
            ),
            const SizedBox(
              height: 5,
            ),
            Text("New following you . h1",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontSize: 14, color: SecondaryText)), // Placeholder color
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: follow == false ? 50 : 30),
            child: CustomButton(
              height: 40,
              color: follow == false ? primary : form,
              textColor: follow == false ? Colors.white : mainText,
              onTap: () {
                setState(() {
                  follow = !follow;
                });
              },
              text: "Follow",
            ),
          ),
        ),
      ],
    );
  }
}
