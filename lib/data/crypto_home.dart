class Crypto_Home {
  String cryptonames, cryptosymbols;
  double daychange, cryptoprices;
  int logoId;
  Crypto_Home(
      {required this.cryptonames,
      required this.cryptoprices,
      required this.cryptosymbols,
      required this.daychange,
      required this.logoId});
}

class Alert_List {
  String crypto;
  String riseAbove, fallBelow;
  Alert_List(
      {required this.crypto, required this.riseAbove, required this.fallBelow});
}
