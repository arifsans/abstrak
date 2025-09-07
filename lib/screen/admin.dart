import 'package:abstrak/main.dart';
import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/notifier/admin_notifier.dart';
import 'package:abstrak/widgets/animation_card.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final AdminNotifier _admin = AdminNotifier();

  @override
  void initState() {
    super.initState();
    _admin.getArtwerk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'CONTENT MANAGEMENT',
          style: customTextTheme.titleLarge?.copyWith(
            fontFamily: 'Kenzo',
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF1a1a1a),
      body: Padding(
        padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
            ? const EdgeInsets.all(0)
            : EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * .3,
              ),
        child: ValueListenableBuilder(
          valueListenable: _admin.data,
          builder: (context, value, child) {
            var data = value?.data?.result ?? [];
            final List<Result> leftColumnImages = [];
            final List<Result> rightColumnImages = [];

            for (int i = 0; i < data.length; i++) {
              if (i % 2 == 0) {
                leftColumnImages.add(data[i]);
              } else {
                rightColumnImages.add(data[i]);
              }
            }

            if (data.isEmpty) {
              return Container();
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  child: Column(
                    children: leftColumnImages.map(
                      (res) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                AnimationCard(
                                  imageUrl: res.image ?? '',
                                  authorName: res.creatorName ?? '',
                                  imageName: res.name ?? '',
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Icon(
                                    res.status == '1'
                                        ? Icons.check_circle
                                        : Icons.pending_actions_rounded,
                                    color: res.status == '1'
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(width: 8), // Spacing between columns

                // Right column
                Expanded(
                  child: Column(
                    children: rightColumnImages.map(
                      (res) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                AnimationCard(
                                  imageUrl: res.image ?? '',
                                  authorName: res.creatorName ?? '',
                                  imageName: res.name ?? '',
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Icon(
                                    res.status == '1'
                                        ? Icons.check_circle
                                        : Icons.pending_actions_rounded,
                                    color: res.status == '1'
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
