import 'package:abstrak/x_button.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class FooterSite extends StatelessWidget {
  FooterSite({super.key, required this.onPressed});

  final Function(String route) onPressed;

  final List<FooterObject> footers = [
    FooterObject(
      text: 'CONTACT CUSTOMER SERVICE',
      route: 'support',
    ),
    FooterObject(
      text: 'TERMS',
      route: 'terms',
    ),
    FooterObject(
      text: 'PRIVACY',
      route: 'privacy',
    ),
    FooterObject(
      text: 'COOKIE POLICY',
      route: 'cookie-policy',
    ),
    FooterObject(
      text: 'DO NOT SELL MY PERSONAL INFORMATION',
      route: 'do-not-sell-my-personal-information',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        spacing: 40,
        children: footers
            .mapIndexed((index, item) => XButton(
                  onPressed: () => onPressed(item.route),
                  text: item.text,
                ))
            .toList(),
      ),
    );
  }
}

class FooterObject {
  final String text;
  final String route;

  FooterObject({required this.text, required this.route});
}
