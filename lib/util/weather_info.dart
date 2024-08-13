class City {
  final String nameEn;
  final String nameTh;

  City({required this.nameEn, required this.nameTh});
}

class Weather {
  final double temp;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String thDescription;

  Weather({
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.thDescription,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temp: json['main']['temp'].toDouble(),
      minTemp: json['main']['temp_min'].toDouble(),
      maxTemp: json['main']['temp_max'].toDouble(),
      description: json['weather'][0]['description'],
      thDescription: json['weather'][0]['description'],
    );
  }
}

String getWeatherIcon(String? weatherDescription) {
  if (weatherDescription == null) {
    return 'https://lottie.host/b309bd30-900a-4277-84c6-17b722ac2fbe/SOYSCykHu9.json';
  }
  // Mapping weather descriptions to Lottie files
  switch (weatherDescription.toLowerCase()) {
    case 'clear sky':
      return 'https://lottie.host/8f9db2f7-be42-4b47-8edd-d96e636b6428/UUVHOhvtmu.json';
    case 'เมฆเล็กน้อย':
      return 'https://lottie.host/4e0a91ef-b610-4e10-897e-b4990c1c5e24/HKzpyTFmvd.json';
    case 'เมฆกระจาย':
      return 'https://lottie.host/35dbd04e-c97a-4d1c-808a-7f4c2067be2b/keCumYvG1z.json';
    case 'เมฆเป็นหย่อม ๆ':
      return 'https://lottie.host/4e0a91ef-b610-4e10-897e-b4990c1c5e24/HKzpyTFmvd.json';
    case 'scattered clouds':
      return 'https://lottie.host/f4f2dcc4-76cc-47a0-9580-c73d3b8dcc8e/VBRWdgPNSg.json';
    case 'เมฆเต็มท้องฟ้า':
      return 'https://lottie.host/f4f2dcc4-76cc-47a0-9580-c73d3b8dcc8e/VBRWdgPNSg.json';
    case 'ฝนปานกลาง':
      return 'https://lottie.host/32dd4dac-9cd3-41c3-bacc-355c672c6e8b/8fL5L5q6re.json';
    case 'ฝนเบา ๆ':
      return 'https://lottie.host/32dd4dac-9cd3-41c3-bacc-355c672c6e8b/8fL5L5q6re.json';
    case 'ฝนตกหนัก':
      return 'https://lottie.host/1dbc08a7-72ff-4252-8c9f-85acdeb268db/Iq0RgLKPoZ.json';
    default:
      return 'https://lottie.host/4e0a91ef-b610-4e10-897e-b4990c1c5e24/HKzpyTFmvd.json'; // Default fallback
  }
}
