import 'package:abstrak/footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hovering/hovering.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List cart = [];
  late AnimationController _controller;
  late VideoPlayerController _vidController;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> katalogs = [
    SizedBox(
      width: 250,
      child: Column(
        children: [
          HoverWidget(
            hoverChild: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-kangaroo-65f9ba7bcf12e.jpg?crop=0.8777056277056277xw:1xh;center,top&resize=980:*'),
            child: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-animals-goat-65f8b2c23aa1f.jpg?crop=0.668xw:1.00xh;0.0629xw,0&resize=980:*'),
            onHover: (event) {},
          ),
          const SizedBox(height: 8),
          const Text('IMAGE 1'),
        ],
      ),
    ),
    SizedBox(
      width: 250,
      child: Column(
        children: [
          HoverWidget(
            hoverChild: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-animals-cow-65f8b2938fcfe.jpg?crop=0.668xw:1.00xh;0.0442xw,0&resize=980:*'),
            child: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-animals-sheep-65f8b2d3f388d.jpg?crop=0.672xw:1.00xh;0.129xw,0&resize=980:*'),
            onHover: (event) {},
          ),
          const SizedBox(height: 8),
          const Text('IMAGE 2'),
        ],
      ),
    ),
    SizedBox(
      width: 250,
      child: Column(
        children: [
          HoverWidget(
            hoverChild: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-animals-kitten-puppy-65f9ba498b3e3.jpg?crop=0.668xw:1.00xh;0.0952xw,0&resize=980:*'),
            child: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-animals-moose-65f8afd2e415f.jpg?crop=0.7954662545079856xw:1xh;center,top&resize=980:*'),
            onHover: (event) {},
          ),
          const SizedBox(height: 8),
          const Text('IMAGE 3'),
        ],
      ),
    ),
    SizedBox(
      width: 250,
      child: Column(
        children: [
          HoverWidget(
            hoverChild: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-animals-squirrel-65f8af699911d.jpg?crop=0.5619834710743802xw:1xh;center,top&resize=980:*'),
            child: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-animals-hedgehog-65f8af918f516.jpg?crop=0.6643126177024482xw:1xh;center,top&resize=980:*'),
            onHover: (event) {},
          ),
          const SizedBox(height: 8),
          const Text('IMAGE 4'),
        ],
      ),
    ),
    SizedBox(
      width: 250,
      child: Column(
        children: [
          HoverWidget(
            hoverChild: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-animals-alpaca-65f9ba20d1c74.jpg?crop=0.6629055007052186xw:1xh;center,top&resize=980:*'),
            child: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-tiger-65f9ba5e78676.jpg?crop=0.6643126177024482xw:1xh;center,top&resize=980:*'),
            onHover: (event) {},
          ),
          const SizedBox(height: 8),
          const Text('IMAGE 5'),
        ],
      ),
    ),
    SizedBox(
      width: 250,
      child: Column(
        children: [
          HoverWidget(
            hoverChild: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-animals-fox-65f8b30255c8f.jpg?crop=0.668xw:1.00xh;0.160xw,0&resize=980:*'),
            child: Image.network(
                'https://hips.hearstapps.com/hmg-prod/images/baby-animals-possums-65f8b314db21b.jpg?crop=0.7337951509153884xw:1xh;center,top&resize=980:*'),
            onHover: (event) {},
          ),
          const SizedBox(height: 8),
          const Text('IMAGE 6'),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    _vidController = VideoPlayerController.asset('assets/videos/home_vid.mp4');
    _vidController.setLooping(true);
    _vidController.initialize();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Full rotation in 60 seconds
    )..repeat(); // This will loop the animation
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _vidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      endDrawer: Drawer(
        shape: const ContinuousRectangleBorder(),
        backgroundColor: Colors.black,
        width: ResponsiveBreakpoints.of(context).isDesktop
            ? MediaQuery.sizeOf(context).width * 0.4
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CART (0 ITEMS)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      scaffoldKey.currentState!.closeEndDrawer();
                    },
                    child: const Text(
                      'Close X',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: cart.isEmpty
                    ? const Center(
                        child: Text(
                          'YOUR CART IS EMPTY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    : ListView(
                        children: cart
                            .map(
                              (e) => Container(),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: PinnedHeader(
                widget: Container(
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CART 0',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.transparent,
                            ),
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _controller.value * 2.0 * 3.1415926535897932,
                            child: child,
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: 60,
                          height: 60,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => scaffoldKey.currentState!.openEndDrawer(),
                        child: Text(
                          'CART 0',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          ResponsiveBreakpoints.of(context).isDesktop ? 48 : 16,
                    ),
                    child: Column(
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
                              child: Container(
                                color: Colors.transparent,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    VideoPlayer(_vidController),
                                    Visibility(
                                      visible: !_vidController.value.isPlaying,
                                      child: const Icon(
                                        Icons.play_circle_filled_rounded,
                                        size: 80,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
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
                        FooterSite(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PinnedHeader extends SliverPersistentHeaderDelegate {
  final Widget? widget;
  PinnedHeader({this.widget});
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(child: widget);
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
