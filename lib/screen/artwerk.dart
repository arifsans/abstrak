import 'package:abstrak/model/artwerks_model.dart';
import 'package:abstrak/notifier/artwerk_notifier.dart';
import 'package:abstrak/widgets/animation_card.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ArtWerk extends StatefulWidget {
  const ArtWerk({super.key});

  @override
  State<ArtWerk> createState() => _ArtWerkState();
}

class _ArtWerkState extends State<ArtWerk> {
  final ArtwerkNotifier _artWerk = ArtwerkNotifier();

  @override
  void initState() {
    _artWerk.getArtwerk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
          ? const EdgeInsets.all(0)
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .3,
            ),
      child: ValueListenableBuilder(
        valueListenable: _artWerk.data,
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
                          child: AnimationCard(
                            imageUrl: res.image ?? '',
                            authorName: res.creatorName ?? '',
                            imageName: res.name ?? '',
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
                          child: AnimationCard(
                            imageUrl: res.image ?? '',
                            authorName: res.creatorName ?? '',
                            imageName: res.name ?? '',
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
    );
  }
}
