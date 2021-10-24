import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));
String reviewToJson(CustomerReview data) => json.encode(data.toJson());

class Review {
  Review({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "customerReviews":
            List<dynamic>.from(customerReviews.map((x) => x.toJson())),
      };
}

class CustomerReview {
  String? id;
  String? name;
  String? review;
  String? date;

  CustomerReview({this.id, this.name, this.review, this.date});

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }

  Map<String, String> toJson() {
    return {
      'id': id!,
      'name': name!,
      'review': review!,
    };
  }
}
