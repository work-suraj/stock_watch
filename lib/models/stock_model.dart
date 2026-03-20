class Stock {
  final String id;
  final String name;
  final double price;
  final double changePercentage;

  const Stock({
    required this.id,
    required this.name,
    required this.price,
    required this.changePercentage,
  });
}

final List<Stock> mockStocks = [
  const Stock(id: '1', name: 'Apple (AAPL)', price: 178.72, changePercentage: 1.25),
  const Stock(id: '2', name: 'Google (GOOGL)', price: 141.80, changePercentage: -0.58),
  const Stock(id: '3', name: 'Amazon (AMZN)', price: 185.07, changePercentage: 2.10),
  const Stock(id: '4', name: 'Microsoft (MSFT)', price: 378.91, changePercentage: 0.75),
  const Stock(id: '5', name: 'Tesla (TSLA)', price: 248.42, changePercentage: -1.83),
  const Stock(id: '6', name: 'Meta (META)', price: 505.75, changePercentage: 3.12),
  const Stock(id: '7', name: 'Netflix (NFLX)', price: 628.30, changePercentage: -0.42),
  const Stock(id: '8', name: 'Nvidia (NVDA)', price: 875.28, changePercentage: 4.56),
  const Stock(id: '9', name: 'AMD (AMD)', price: 164.12, changePercentage: -2.34),
  const Stock(id: '10', name: 'Disney (DIS)', price: 112.56, changePercentage: 0.18),
];
