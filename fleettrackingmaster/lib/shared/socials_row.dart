import 'package:flutter/material.dart';

class SocialAppRow extends StatelessWidget {
  const SocialAppRow({
    Key? key,
    required this.title,
    this.userIcon = "",
    this.colorl = Colors.orangeAccent,
    this.subtitle = "x"
  }) : super(key: key);

  final String title, userIcon, subtitle;
  final Color colorl;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
          color: colorl,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 40,
            child: VerticalDivider(
              // thickness: 5,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          userIcon == ""? Image.asset("images/img2.jpg", width:50, height: 50,): Image.network(userIcon, width:50, height: 50,)
        ],
      ),
    );
  }
}
