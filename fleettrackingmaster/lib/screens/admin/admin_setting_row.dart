import 'package:flutter/material.dart';

class ESRow extends StatelessWidget {
  const ESRow({
    Key? key,
    required this.title,
    this.iconsSrc = "images/img.png",
    this.colorl = Colors.pink,

  }) : super(key: key);

  final String title, iconsSrc;
  final Color colorl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11.5),
      decoration: BoxDecoration(
          color: colorl,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.fade,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 40,
                    width: 3,
                    color: Colors.black,
                  ),
                ),
                Image.asset(
                  iconsSrc,
                  height: 35,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}