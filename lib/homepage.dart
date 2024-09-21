import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _vidController;

  List<Widget> katalogs = [
    SizedBox(
      width: 250,
      child: Column(
        children: [
          HoverWidget(
            hoverChild: Image.network(
              'http://arifsani.xyz/src/hoodie-blck-back.png',
            ),
            child: Image.network(
              'http://arifsani.xyz/src/hoodie-blck-front.png',
            ),
            onHover: (event) {},
          ),
          const SizedBox(height: 8),
          const Text('Hoodie Black Captive'),
          const SizedBox(height: 3),
          const Text('IDR 666.000,00'),
        ],
      ),
    ),
    SizedBox(
      width: 250,
      child: Column(
        children: [
          HoverWidget(
            hoverChild: Image.network(
              'http://arifsani.xyz/src/hoodie-blue-back.png',
            ),
            child: Image.network(
              'http://arifsani.xyz/src/hoodie-blue-front.png',
            ),
            onHover: (event) {},
          ),
          const SizedBox(height: 8),
          const Text('Hoodie Blue Captive'),
          const SizedBox(height: 3),
          const Text('IDR 666.000,00'),
        ],
      ),
    ),
    SizedBox(
      width: 250,
      child: Column(
        children: [
          HoverWidget(
            hoverChild: Image.network(
              'http://arifsani.xyz/src/hoodie-brwn-back.png',
            ),
            child: Image.network(
              'http://arifsani.xyz/src/hoodie-brwn-front.png',
            ),
            onHover: (event) {},
          ),
          const SizedBox(height: 8),
          const Text('Hoodie Brown Captive'),
          const SizedBox(height: 3),
          const Text('IDR 666.000,00'),
        ],
      ),
    ),
    SizedBox(
      width: 250,
      child: Column(
        children: [
          Image.network(
            'http://arifsani.xyz/src/album-warrior-img.png',
          ),
          const SizedBox(height: 8),
          const Text('WARRIOR ALBUM - DELUXE VINYL RECORD'),
          const SizedBox(height: 3),
          const Text('IDR 123.000,00'),
        ],
      ),
    ),
    SizedBox(
      width: 250,
      child: Column(
        children: [
          Image.network(
            'http://arifsani.xyz/src/album-rise-img.png',
          ),
          const SizedBox(height: 8),
          const Text('RISE ALBUM - DELUXE VINYL RECORD'),
          const SizedBox(height: 3),
          const Text('IDR 123.000,00'),
        ],
      ),
    ),
    SizedBox(
      width: 250,
      child: Column(
        children: [
          Image.network(
            'http://arifsani.xyz/src/album-rise-img.png',
          ),
          const SizedBox(height: 8),
          const Text('CAPTIVE KINGS - DELUXE POSTER ALBUM'),
          const SizedBox(height: 3),
          const Text('IDR 65.000,00'),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    _vidController = VideoPlayerController.networkUrl(
      Uri.parse('https://arifsani.xyz/home_vid.mp4'),
    );
    _vidController.setLooping(true);
    _vidController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _vidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: ResponsiveBreakpoints.of(context).isDesktop
              ? MediaQuery.sizeOf(context).height * 0.75
              : MediaQuery.sizeOf(context).height * 0.3,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_vidController.value.isPlaying) {
                    _vidController.pause();
                  } else {
                    _vidController.play();
                  }
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_vidController),
                  Visibility(
                    visible: !_vidController.value.isPlaying,
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 85,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 40,
          runSpacing: 40,
          children: katalogs
              .sublist(0, 3)
              .map(
                (item) => item,
              )
              .toList(),
        ),
        const SizedBox(height: 40),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 40,
          runSpacing: 40,
          children: katalogs
              .sublist(3, 5)
              .map(
                (item) => item,
              )
              .toList(),
        ),
        const SizedBox(height: 40),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 40,
          runSpacing: 40,
          children: katalogs
              .sublist(5)
              .map(
                (item) => item,
              )
              .toList(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
