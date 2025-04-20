class Token {
  final String name;
  final String symbol;
  final double price;
  final double priceChange;
  final String imageUrl;

  Token({
    required this.name,
    required this.symbol,
    required this.price,
    required this.priceChange,
    required this.imageUrl,
  });
}

class NFT {
  final String id;
  final String name;
  final String imageUrl;
  final String description;

  NFT({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });
}
