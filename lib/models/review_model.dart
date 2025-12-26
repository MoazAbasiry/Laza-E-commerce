class ReviewModel {
  final String id;
  final String productId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(String id, Map<String, dynamic> map) {
    return ReviewModel(
      id: id,
      productId: map['productId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }
}