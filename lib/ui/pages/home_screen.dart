import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/animation/stagered_animation.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/ui/widgets/alert_state.dart';
import 'package:restaurant_app/ui/widgets/custom_dialog.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/provider/list_restaurant_provider.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkYellowColor,
      body: SafeArea(
        child: SlidingUpPanel(
          color: scaffoldColor,
          minHeight: MediaQuery.of(context).size.height / 1.77,
          maxHeight: MediaQuery.of(context).size.height,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          boxShadow: const [
            BoxShadow(blurRadius: 0, color: Colors.transparent),
          ],
          panelBuilder: (ScrollController _scrollController) =>
              _panelDetail(_scrollController),
          body: Center(child: _headerPart(context)),
        ),
      ),
    );
  }

  Widget _headerPart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: StaggeredAnimation(
        offset: -20,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                child: Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.blueGrey[300],
                ),
                backgroundColor: whiteColor,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      style: whiteTextStyle,
                    ),
                    Text(
                      'Dicoding Academy',
                      style: whiteTextStyle.copyWith(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              PopupMenuButton(
                offset: const Offset(-10, 40),
                icon: Icon(
                  Iconsax.notification,
                  color: whiteColor,
                  size: 27,
                ),
                color: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: SizedBox(
                        width: 80,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.notifications_off,
                              size: 25,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'No New Notifications!',
                              textAlign: TextAlign.center,
                              style: greyTextStyle.copyWith(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'What restaurant are you\nlooking for?',
            style: whiteTextStyle.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, searchRoute),
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.search_normal),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17),
                      hintText: 'Name, Category or Menu',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xffA6A1A1),
                      ),
                      filled: true,
                      fillColor: whiteColor,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: darkYellowColor,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () => showComingsoonFeature(context),
                  icon: const Icon(Iconsax.category),
                  iconSize: 30,
                  splashRadius: 25,
                  color: greyColor,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _panelDetail(ScrollController _scrollController) {
    return ListView(
      controller: _scrollController,
      children: [
        Container(
          decoration: BoxDecoration(
            color: scaffoldColor,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 100),
            child: StaggeredAnimation(
              offset: 20,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: blackTextStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(context, resultRoute,
                            arguments: categories[index]),
                        child: Container(
                          width: 120,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange,
                                Colors.orangeAccent,
                                Colors.amber,
                                yellowColor,
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              stops: const [0, 0.2, 0.5, 0.8],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              categories[index],
                              style: whiteTextStyle.copyWith(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 10),
                    itemCount: categories.length,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Recomended for you',
                  style: blackTextStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 10),
                Consumer<ListRestaurantProvider>(
                  builder: (context, state, widget) {
                    if (state.state == ResultState.Loading) {
                      return Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 8,
                            ),
                            ResultStateAlert.loading(context),
                          ],
                        ),
                      );
                    } else if (state.state == ResultState.HasData) {
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          var restaurantElement =
                              state.restaurant.restaurants[index];
                          return RestaurantsCard(restaurantElement);
                        },
                        itemCount: state.restaurant.restaurants.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                      );
                    } else if (state.state == ResultState.NoData) {
                      return ResultStateAlert.noData(state.message);
                    } else if (state.state == ResultState.Error) {
                      return ResultStateAlert.error();
                    } else {
                      return const Text('');
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
