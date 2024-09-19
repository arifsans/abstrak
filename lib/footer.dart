import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FooterSite extends StatelessWidget {
  FooterSite({super.key});

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
            .map(
              (item) => GestureDetector(
                onTap: () => context.goNamed(item.route),
                child: Text(
                  item.text,
                  style: ResponsiveBreakpoints.of(context).isDesktop
                      ? Theme.of(context).textTheme.titleMedium
                      : Theme.of(context).textTheme.titleSmall,
                ),
              ),
            )
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
