enum ExchangeTier {
  lowEnd,
  midRange,
  highEnd,
}

extension ExchangeTierX on ExchangeTier {
  String get label {
    const labels = {
      'lowEnd': 'Low End',
      'midRange': 'Mid Range',
      'highEnd': 'High End',
    };
    return labels[name]!;
  }

  String get range {
    const ranges = {
      'lowEnd': 'Under 50K',
      'midRange': '50K–150K',
      'highEnd': '150K+',
    };
    return ranges[name]!;
  }

  int get minPrice {
    const minPrices = {
      'lowEnd': 0,
      'midRange': 50000,
      'highEnd': 150000,
    };
    return minPrices[name]!;
  }

  int get maxPrice {
    const maxPrices = {
      'lowEnd': 50000,
      'midRange': 150000,
      'highEnd': 999999999,
    };
    return maxPrices[name]!;
  }

  static ExchangeTier fromPrice(int price) {
    if (price < 50000) return ExchangeTier.lowEnd;
    if (price < 150000) return ExchangeTier.midRange;
    return ExchangeTier.highEnd;
  }
}
