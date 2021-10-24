import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/animation/stagered_animation.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/provider/database_provider.dart';
import 'package:restaurant_app/data/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/ui/pages/detail_screen.dart';
import 'package:restaurant_app/ui/pages/menu_screen.dart';
import 'package:restaurant_app/ui/pages/review_screen.dart';
import 'package:restaurant_app/ui/widgets/image_view.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:shimmer/shimmer.dart';

class CustomSliverAppBar extends StatefulWidget {
  const CustomSliverAppBar({required this.restaurantElement, Key? key})
      : super(key: key);
  final RestaurantElement restaurantElement;

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    Provider.of<DetailRestaurantProvider>(context, listen: false)
        .fetchDetailRestaurant(widget.restaurantElement.id!);

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: yellowColor,
                expandedHeight: MediaQuery.of(context).size.height / 2.7,
                floating: false,
                pinned: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, size: 30, color: whiteColor),
                ),
                actions: [
                  Consumer<DatabaseProvider>(
                    builder: (context, state, child) {
                      return FutureBuilder<bool>(
                        future: state.isFavorite(widget.restaurantElement.id!),
                        builder: (context, snapshot) {
                          var _isFavorited = snapshot.data ?? true;
                          return _isFavorited
                              ? IconButton(
                                  onPressed: () {
                                    state.removeFavoriteResto(
                                        widget.restaurantElement.id!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(milliseconds: 600),
                                        content: Text(
                                            'You subtracted in favorite list!'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.favorite, size: 30),
                                  color: Colors.red)
                              : IconButton(
                                  onPressed: () {
                                    state.addFavoriteResto(
                                        widget.restaurantElement);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(milliseconds: 600),
                                        content:
                                            Text('You added in favorite list!'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.favorite, size: 30),
                                  color: whiteColor);
                        },
                      );
                    },
                  ),
                ],
                flexibleSpace: CustomFlexibleSpaceBar(widget.restaurantElement),
              ),
              SliverPersistentHeader(
                floating: false,
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: yellowColor,
                    unselectedLabelColor: Colors.grey,
                    labelStyle:
                        greyTextStyle.copyWith(fontWeight: FontWeight.w500),
                    tabs: const <Widget>[
                      Tab(icon: Icon(Icons.info), text: "Information"),
                      Tab(icon: Icon(Icons.menu_book), text: "Menu"),
                      Tab(icon: Icon(Icons.rate_review), text: "Review"),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              DetailScreen(widget.restaurantElement),
              MenuScreen(widget.restaurantElement),
              ReviewScreen(widget.restaurantElement),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: whiteColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class CustomFlexibleSpaceBar extends StatefulWidget {
  const CustomFlexibleSpaceBar(this.restaurantElement, {Key? key})
      : super(key: key);
  final RestaurantElement restaurantElement;

  @override
  State<CustomFlexibleSpaceBar> createState() => _CustomFlexibleSpaceBarState();
}

class _CustomFlexibleSpaceBarState extends State<CustomFlexibleSpaceBar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return Consumer<DetailRestaurantProvider>(
          builder: (context, provider, child) {
            if (provider.state == ResultState.Loading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.3,
                  color: blackColor,
                ),
              );
            } else if (provider.state == ResultState.HasData) {
              return Stack(
                children: [
                  SafeArea(
                    child: Center(
                      child: Opacity(
                        opacity: 1 - opacity,
                        child: Text(
                          widget.restaurantElement.name,
                          textAlign: TextAlign.center,
                          style: whiteTextStyle.copyWith(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: opacity,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ImageView(
                          urlImage: largePicture,
                          idPicture: widget.restaurantElement.pictureId,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.3,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.1,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.black.withAlpha(0),
                                greyColor.withOpacity(0.4),
                                Colors.black87,
                              ],
                            ),
                          ),
                        ),
                        _titlePart(widget.restaurantElement)
                      ],
                    ),
                  ),
                ],
              );
            } else if (provider.state == ResultState.NoData) {
              return Stack(
                children: [
                  SafeArea(
                    child: Center(
                      child: Opacity(
                        opacity: 1 - opacity,
                        child: Text(
                          '',
                          textAlign: TextAlign.center,
                          style: whiteTextStyle.copyWith(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: opacity,
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 75),
                            Icon(
                              Icons.image_not_supported_outlined,
                              size: 50,
                              color: whiteColor,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Image Failed to Load',
                              style: whiteTextStyle.copyWith(fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else if (provider.state == ResultState.Error) {
              return Stack(
                children: [
                  SafeArea(
                    child: Center(
                      child: Opacity(
                        opacity: 1 - opacity,
                        child: Text(
                          '',
                          textAlign: TextAlign.center,
                          style: whiteTextStyle.copyWith(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: opacity,
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 75),
                            Icon(
                              Icons.image_not_supported_outlined,
                              size: 50,
                              color: whiteColor,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Image Failed to Load',
                              style: whiteTextStyle.copyWith(fontSize: 20),
                            ),
                            Text(
                              'Check your connection',
                              style: whiteTextStyle.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text(''));
            }
          },
        );
      },
    );
  }

  Widget _titlePart(RestaurantElement restaurantElement) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: StaggeredAnimation(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        offset: -20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantElement.name,
                      style: whiteTextStyle.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          restaurantElement.city,
                          style: whiteTextStyle.copyWith(fontSize: 16),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: yellowColor,
                    size: 30,
                  ),
                  const SizedBox(width: 5),
                  Column(
                    children: [
                      Text('Rating', style: whiteTextStyle),
                      Text.rich(
                        TextSpan(
                          text: '${restaurantElement.rating}',
                          style: whiteTextStyle,
                          children: [
                            TextSpan(text: ' / 5.0', style: whiteTextStyle)
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
