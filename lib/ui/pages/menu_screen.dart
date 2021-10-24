import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/animation/stagered_animation.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/ui/widgets/alert_state.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/ui/widgets/menu_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen(this.restaurantElement, {Key? key}) : super(key: key);
  final RestaurantElement restaurantElement;

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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
                offset: 20.0,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      children: [
                        MenuField(
                          title: 'Foods',
                          menuCard: FoodsCard(state.detailRestaurant),
                        ),
                        const SizedBox(height: 5),
                        MenuField(
                          title: 'Drinks',
                          menuCard: DrinksCard(state.detailRestaurant),
                        ),
                      ],
                    ),
                  )
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
}

class MenuField extends StatelessWidget {
  const MenuField({required this.title, required this.menuCard, Key? key})
      : super(key: key);

  final Widget menuCard;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: blackTextStyle.copyWith(fontSize: 20),
                ),
              ),
            ),
            DottedBorder(
              color: Colors.grey.shade400,
              dashPattern: const [10, 10],
              padding: const EdgeInsets.all(0),
              child: Container(
                width: MediaQuery.of(context).size.width - 60,
              ),
            ),
            menuCard
          ],
        ),
      ),
    );
  }
}
