import 'package:researchproject/constans/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomLikedNotifcation extends StatelessWidget {
  const CustomLikedNotifcation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: Stack(children: const [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("asset/user_.png"),
              ),
            ),
            Positioned(
              bottom: 12,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("asset/user_.png"),
              ),
            ),
          ]),
        ),
        const SizedBox(
          width: 3,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                maxLines: 2,
                text: TextSpan(
                    text: "John Steve",
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 18, color: mainText),
                    children: [
                      TextSpan(
                        text: " and \n",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: SecondaryText),
                      ),
                      const TextSpan(
                          text: "Sam Wincherter",
                          style: TextStyle(
                            fontSize: 18,
                          ))
                    ]),
              ),
              const SizedBox(
                height: 5,
              ),
              Text("Liked your recipe  .  h1",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: SecondaryText))
            ],
          ),
        ),
        Image.asset(
          "asset/picnic-table.png",
          height: 55,
          width: 55,
        ),
      ],
    );
  }
}
