class CardModel {
  final String id;
  final String cardHolder;
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  CardModel({
    required this.id,
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  // تحويل البيانات لـ Map لحفظها في Firestore 
  Map<String, dynamic> toMap() {
    return {
      'cardHolder': cardHolder,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }

  // جلب البيانات من Firestore [cite: 64]
  factory CardModel.fromMap(String id, Map<String, dynamic> map) {
    return CardModel(
      id: id,
      cardHolder: map['cardHolder'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cvv: map['cvv'] ?? '',
    );
  }
}