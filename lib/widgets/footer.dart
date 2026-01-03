import 'package:abstrak/base/api_state.dart';
import 'package:abstrak/main.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class FooterSite extends StatelessWidget {
  FooterSite({super.key, this.onPressed});

  final Function(String route)? onPressed;

  final List<FooterObject> footers = [
    FooterObject(
      text: 'HOME',
      route: 'home',
    ),
    FooterObject(
      text: 'ABOUT',
      route: 'about',
    ),
    FooterObject(
      text: 'ARTWERK',
      route: 'artwerk',
    ),
    FooterObject(
      text: 'MANIFESTO',
      route: 'manifesto',
    ),
    FooterObject(
      text: 'TP CALCULATOR',
      route: 'tp-calculator',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: userNotifier.user,
        builder: (context, value, child) {
          var tempFooters = [...this.footers];
          if (value.status == ApiStatus.success && value.data?.data?.roleId != null) {
            try {
              if (int.parse(value.data!.data!.roleId!) >= 3) {
                tempFooters.add(
                  FooterObject(
                    text: 'CATALOGS',
                    route: 'catalogs',
                  ),
                );
              }
            } catch (e) {
              // Ignore parsing error
            }
          }
          return Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            spacing: 16,
            children: tempFooters
                .mapIndexed(
                  (index, item) => GestureDetector(
                    onTap: () {
                      if (onPressed != null) {
                        onPressed!(item.route);
                      }
                    },
                    child: Text(
                      item.text,
                      style: TextStyle(
                        fontFamily: 'Kenzo',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        });
  }
}

class FooterObject {
  final String text;
  final String route;

  FooterObject({required this.text, required this.route});
}
