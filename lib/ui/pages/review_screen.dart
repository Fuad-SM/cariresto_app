import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:restaurant_app/common/animation/stagered_animation.dart';
import 'package:restaurant_app/common/theme/theme.dart';
import 'package:restaurant_app/ui/widgets/alert_state.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/ui/widgets/review_modalbottom.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen(this.restaurantElement, {Key? key}) : super(key: key);
  final RestaurantElement restaurantElement;

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _refreshController = RefreshController(initialRefresh: false);

  Future<void> _getRefreshData(DetailRestaurantProvider state) async {
    Provider.of<DetailRestaurantProvider>(context, listen: false)
        .fetchDetailRestaurant(state.detailRestaurant.restaurant.id!);
    _refreshController.refreshCompleted();
    state.setState(ResultState.Loading);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DetailRestaurantProvider>(context, listen: false)
        .fetchDetailRestaurant(widget.restaurantElement.id!);
    return Scaffold(
      body: Stack(
        children: [
          Consumer<DetailRestaurantProvider>(
            builder: (context, state, widget) {
              if (state.state == ResultState.Loading) {
                return ResultStateAlert.loading(context);
              } else if (state.state == ResultState.HasData) {
                return SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  header: const MaterialClassicHeader(),
                  onRefresh: () async => _getRefreshData(state),
                  child: ListView(
                    children: [
                      StaggeredAnimationDetail(
                        offset: 20,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  children: [
                                    _titlePart(),
                                    _reviewPart(state),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
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
          _customFAB(context)
        ],
      ),
    );
  }

  Widget _titlePart() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: yellowColor, width: 2),
        ),
      ),
      child: Text(
        'What Are\nPeople Saying',
        style: blackTextStyle.copyWith(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _reviewPart(DetailRestaurantProvider state) {
    return ListView.separated(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final review =
              state.detailRestaurant.restaurant.customerReviews[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                '${review.review}',
                style: greyTextStyle.copyWith(
                    fontSize: 15, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 5),
              Text(
                '${review.date}',
                style: greyTextStyle.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 5),
              Text(
                'By: ${review.name}',
                style: blackTextStyle,
              ),
              const SizedBox(height: 10),
            ],
          );
        },
        separatorBuilder: (context, index) => DottedBorder(
              color: Colors.grey.shade400,
              dashPattern: const [10, 10],
              padding: const EdgeInsets.all(0),
              child: Container(),
            ),
        itemCount: state.detailRestaurant.restaurant.customerReviews.length);
  }

  Widget _customFAB(BuildContext context) {
    return StaggeredAnimation(
      offset: 50,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 20),
            child: SizedBox(
              width: 55,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  primary: yellowColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            right: 35,
                            left: 35,
                          ),
                          child: ReviewModal(id: widget.restaurantElement.id!),
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.create,
                  size: 30,
                  color: whiteColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
