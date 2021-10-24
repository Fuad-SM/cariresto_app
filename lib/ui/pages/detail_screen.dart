import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/animation/stagered_animation.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/ui/widgets/alert_state.dart';
import 'package:restaurant_app/ui/widgets/custom_dialog.dart';
import 'package:restaurant_app/utils/const.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen(this.restaurantElement, {Key? key}) : super(key: key);
  final RestaurantElement restaurantElement;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<DetailRestaurantProvider>(context, listen: false)
        .fetchDetailRestaurant(widget.restaurantElement.id!);

    return Scaffold(
      body: Consumer<DetailRestaurantProvider>(
        builder: (context, state, widget) {
          if (state.state == ResultState.Loading) {
            return ResultStateAlert.loading(context);
          } else if (state.state == ResultState.HasData) {
            return SingleChildScrollView(
              child: StaggeredAnimationDetail(
                offset: 20,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 30),
                        child: Column(
                          children: [
                            _aboutPart(state),
                            _dividerPart(),
                            _informationPart(state),
                            _dividerPart(),
                            _locationPart(state),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state.state == ResultState.NoData) {
            return ResultStateAlert.noData(state.message);
          } else if (state.state == ResultState.Error) {
            return ResultStateAlert.error();
          } else {
            return const Text('');
          }
        },
      ),
    );
  }

  Widget _aboutPart(DetailRestaurantProvider state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: blackTextStyle.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          state.detailRestaurant.restaurant.description,
          style: greyTextStyle,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _informationPart(DetailRestaurantProvider state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Information',
          style: blackTextStyle.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.food_bank_outlined, color: yellowColor, size: 40),
                  const SizedBox(height: 6),
                  Text(
                    'Food Category:',
                    textAlign: TextAlign.center,
                    style: greyTextStyle,
                  ),
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      primary: true,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final category =
                            state.detailRestaurant.restaurant.categories[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: yellowColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(category.name, style: yellowTextStyle),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemCount:
                          state.detailRestaurant.restaurant.categories.length,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(Iconsax.clock, color: Colors.green, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    'Open Time:',
                    textAlign: TextAlign.center,
                    style: greyTextStyle,
                  ),
                  Text(
                    '10 AM-10 PM',
                    textAlign: TextAlign.center,
                    style: regularBlackTextStyle,
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(Iconsax.edit, color: Colors.blueAccent, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    'Review:',
                    textAlign: TextAlign.center,
                    style: greyTextStyle,
                  ),
                  Text(
                    '${state.detailRestaurant.restaurant.customerReviews.length} People',
                    textAlign: TextAlign.center,
                    style: regularBlackTextStyle,
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Iconsax.medal_star,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rating:',
                    textAlign: TextAlign.center,
                    style: greyTextStyle,
                  ),
                  Text(
                    '${state.detailRestaurant.restaurant.rating} / 5.0',
                    textAlign: TextAlign.center,
                    style: regularBlackTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _locationPart(DetailRestaurantProvider state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: blackTextStyle.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  state.detailRestaurant.restaurant.address,
                  style: greyTextStyle,
                ),
              ),
              CircleAvatar(
                backgroundColor: const Color(0xffF6F7F8),
                maxRadius: 20,
                child: IconButton(
                  onPressed: () => showComingsoonFeature(context),
                  icon: const Icon(Icons.place),
                  color: const Color(0xff989BA1),
                  iconSize: 22,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _dividerPart() {
    return Column(
      children: const <Widget>[
        SizedBox(
          height: 12,
        ),
        Divider(),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
