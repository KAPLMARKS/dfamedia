import 'package:dfamedia/core/widgets/bottom_navigation_bar.dart';
import 'package:dfamedia/features/home/domain/models/banner.dart';
import 'package:dfamedia/features/home/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'wm.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationWrapper(child: const _HomeScreenContent());
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture(
                  width: 22,
                  height: 22,
                  AssetBytesLoader('assets/svg/avatar.svg.vec'),
                )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                ),
            SizedBox(width: 8),
            Text(
                  'Анна',
                  style: TextTheme.of(context).bodyLarge,
                )
                .animate()
                .fadeIn(duration: 600.ms, delay: 300.ms)
                .slideX(begin: -0.2, end: 0.0),
            Spacer(),
            SizedBox(
                  height: 32,
                  width: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: SvgPicture(
                      AssetBytesLoader('assets/svg/bookmarks.svg.vec'),
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms, delay: 400.ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                ),
            SizedBox(width: 4),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: SvgPicture(
                  AssetBytesLoader('assets/svg/notifications.svg.vec'),
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 120,
                  child: Consumer<HomeWM>(
                    builder: (context, wm, child) {
                      return _buildStoriesList(context, wm);
                    },
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 100.ms)
              .slideY(begin: -0.3, end: 0.0),
          SizedBox(height: 8),
          _buildBannerSection()
              .animate()
              .fadeIn(duration: 800.ms, delay: 200.ms)
              .slideY(begin: 0.3, end: 0.0),
          SizedBox(height: 25),
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SvgPicture(AssetBytesLoader('assets/svg/fire.svg.vec')),
                    SizedBox(width: 8),
                    Text(
                      'Хит продаж',
                      style: TextStyle(
                        fontFamily: 'Stolzl',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms)
              .slideX(begin: -0.2, end: 0.0),
          SizedBox(height: 10),
          SizedBox(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Consumer<HomeWM>(
                    builder: (context, wm, child) {
                      final goods = wm.goods;
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: goods.length,
                        itemBuilder: (context, index) {
                          final good = goods[index];
                          return Good(
                                name: good.title,
                                price: good.price,
                                imageUrl: good.image,
                                unitText: good.unitText,
                                onAddToCart: () {},
                              )
                              .animate()
                              .fadeIn(
                                duration: 600.ms,
                                delay: (400 + index * 100).ms,
                              )
                              .slideX(begin: 0.3, end: 0.0)
                              .scale(
                                begin: const Offset(0.9, 0.9),
                                end: const Offset(1.0, 1.0),
                              );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 10),
                      );
                    },
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0.0),
        ],
      ),
    );
  }

  Widget _buildStoriesList(BuildContext context, HomeWM wm) {
    if (wm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: wm.stories.length,
      itemBuilder: (context, index) {
        final story = wm.stories[index];
        return Padding(
          padding: EdgeInsets.only(
            right: index < wm.stories.length - 1 ? 5 : 0,
          ),
          child: GestureDetector(
            onTap: () => wm.onStoryTap(story),
            child: Story(storyData: story),
          ),
        );
      },
    );
  }

  Widget _buildBannerSection() {
    return Consumer<HomeWM>(
      builder: (context, wm, child) {
        return _BannerCarousel(banners: wm.banners);
      },
    );
  }
}

class _BannerCarousel extends StatefulWidget {
  final List<BannerData> banners;

  const _BannerCarousel({required this.banners});

  @override
  _BannerCarouselState createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  int currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 144,
          child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                currentBannerIndex = index;
              });
            },
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: BannerItem(bannerData: banner),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        BannerIndicator(
          currentIndex: currentBannerIndex,
          totalCount: widget.banners.length,
        ),
      ],
    );
  }
}
