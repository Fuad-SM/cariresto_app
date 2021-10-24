import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/data/provider/search_provider.dart';
import 'package:restaurant_app/ui/widgets/alert_state.dart';
import 'package:restaurant_app/ui/widgets/custom_dialog.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';
import 'package:restaurant_app/utils/const.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen(this.query, {Key? key}) : super(key: key);
  final String query;

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<SearchProvider>(context, listen: false)
        .fetchSearch(query: widget.query);
    return Scaffold(
      body: Stack(
        children: [
          _resultSearch(),
          _customAppbar(context),
        ],
      ),
    );
  }

  Widget _customAppbar(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.amber,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: whiteColor),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, searchRoute),
                    child: TextField(
                      enabled: false,
                      style: regularBlackTextStyle,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        suffixIcon: const Icon(Icons.search),
                        hintText: 'Name, Category or Menu',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xffA6A1A1),
                        ),
                        filled: true,
                        fillColor: whiteColor,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => showComingsoonFeature(context),
                  icon: const Icon(Icons.sort),
                  iconSize: 30,
                  color: whiteColor,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _resultSearch() {
    return Consumer<SearchProvider>(
      builder: (context, state, child) {
        if (state.state == ResultState.Idle) {
          return const Center(child: Text(''));
        } else if (state.state == ResultState.Loading) {
          return SearchAlert(
              lottie: 'assets/json/finding_data.json',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              message: '');
        } else if (state.state == ResultState.HasData) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 9,
                    ),
                    Text.rich(
                      TextSpan(
                        text: ' Search Results : ',
                        style: greyTextStyle,
                        children: [
                          TextSpan(
                            text: widget.query,
                            style: blackTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimationLimiter(
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          final restaurantElement =
                              state.search.restaurants[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            child: SlideAnimation(
                              curve: Curves.easeIn,
                              verticalOffset: -20,
                              duration: const Duration(milliseconds: 375),
                              child: FadeInAnimation(
                                child: RestaurantsCard(restaurantElement),
                              ),
                            ),
                          );
                        },
                        itemCount: state.search.restaurants.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                      ),
                    ),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
            ),
          );
        } else if (state.state == ResultState.NoData) {
          return SearchAlert(
              lottie: 'assets/json/not_found.json',
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 4,
              message: state.message);
        } else if (state.state == ResultState.Error) {
          return SearchAlert(
              lottie: 'assets/json/no_internet.json',
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 4,
              message: 'Check\nyour connection');
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}
