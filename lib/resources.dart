import 'package:flutter/material.dart';

///enum for change of price icon
enum ChangeIcon { up, down, steady }

///enum for which days' prices should be displayed
enum DisplayDay { none, today, tomorrow }

///enum for which type of search has been selected
enum SelectedArea { none, region, suburb }

class Resources {
  ///Product display string to RSS value
  static final Map<String, String> productsStringToRss = {
    'Unleaded Petrol': '1',
    'Premium Unleaded': '2',
    'Diesel': '4',
    'LPG': '5',
    '98 RON': '6',
    'E85': '10',
    'Brand Diesel': '11'
  };

  ///Product RSS value to display string
  static final Map<String, String> productsRssToString = {
    '1': 'Unleaded Petrol',
    '2': 'Premium Unleaded',
    '4': 'Diesel',
    '5': 'LPG',
    '6': '98 RON',
    '10': 'E85',
    '11': 'Brand Diesel'
  };

  ///Product RSS value to short display string
  static final Map<String, String> productsShort = {
    '1': 'ULP',
    '2': 'PULP',
    '4': 'D',
    '5': 'LPG',
    '6': '98 RON',
    '10': 'E85',
    '11': 'BD'
  };

  ///Product RSS value to color
  static final Map<String, Color> productsColors = {
    '1': Colors.indigoAccent,
    '2': Colors.purple,
    '4': Colors.teal,
    '5': Colors.tealAccent,
    '6': Colors.yellow,
    '10': Colors.grey,
    '11': Colors.brown
  };

  ///Region display string to RSS value
  static final Map<String, String> regionsStringToRss = {
    'Metro : North of River': '25',
    'Metro : South of River': '26',
    'Metro : East/Hills': '27',
    'Albany': '15',
    'Augusta / Margaret River': '28',
    'Bridgetown / Greenbushes': '30',
    'Boulder': '1',
    'Broome': '2',
    'Bunbury': '16',
    'Busselton (Townsite)': '3',
    'Busselton (Shire)': '29',
    'Capel': '19',
    'Carnarvon': '4',
    'Cataby': '33',
    'Collie': '5',
    'Coolgardie': '34',
    'Cunderdin': '35',
    'Donnybrook / Balingup': '31',
    'Dalwallinu': '36',
    'Dampier': '6',
    'Dardanup': '20',
    'Denmark': '37',
    'Derby': '38',
    'Dongara': '39',
    'Esperance': '7',
    'Exmouth': '40',
    'Fitzroy Crossing': '41',
    'Geraldton': '17',
    'Greenough': '21',
    'Harvey': '22',
    'Jurien': '42',
    'Kalgoorlie': '8',
    'Kambalda': '43',
    'Karratha': '9',
    'Kellerberrin': '44',
    'Kojonup': '45',
    'Kununurra': '10',
    'Mandurah': '18',
    'Manjimup': '32',
    'Meckering': '58',
    'Meekatharra': '46',
    'Moora': '47',
    'Mt Barker': '48',
    'Munglinup': '61',
    'Murray': '23',
    'Narrogin': '11',
    'Newman': '49',
    'Norseman': '50',
    'North Bannister': '60',
    'Northam': '12',
    'Northam (Shire)': '62',
    'Port Hedland': '13',
    'Ravensthorpe': '51',
    'Regans Ford': '57',
    'South Hedland': '14',
    'Tammin': '53',
    'Waroona': '24',
    'Williams': '54',
    'Wubin': '55',
    'Wundowie': '59',
    'York': '56',
  };

  ///Region RSS value to display string
  static final Map<String, String> regionsRssToString = {
    '25': 'Metro : North of River',
    '26': 'Metro : South of River',
    '27': 'Metro : East/Hills',
    '15': 'Albany',
    '28': 'Augusta / Margaret River',
    '30': 'Bridgetown / Greenbushes',
    '1': 'Boulder',
    '2': 'Broome',
    '16': 'Bunbury',
    '3': 'Busselton (Townsite)',
    '29': 'Busselton (Shire)',
    '19': 'Capel',
    '4': 'Carnarvon',
    '33': 'Cataby',
    '5': 'Collie',
    '34': 'Coolgardie',
    '35': 'Cunderdin',
    '31': 'Donnybrook / Balingup',
    '36': 'Dalwallinu',
    '6': 'Dampier',
    '20': 'Dardanup',
    '37': 'Denmark',
    '38': 'Derby',
    '39': 'Dongara',
    '7': 'Esperance',
    '40': 'Exmouth',
    '41': 'Fitzroy Crossing',
    '17': 'Geraldton',
    '21': 'Greenough',
    '22': 'Harvey',
    '42': 'Jurien',
    '8': 'Kalgoorlie',
    '43': 'Kambalda',
    '9': 'Karratha',
    '44': 'Kellerberrin',
    '45': 'Kojonup',
    '10': 'Kununurra',
    '18': 'Mandurah',
    '32': 'Manjimup',
    '58': 'Meckering',
    '46': 'Meekatharra',
    '47': 'Moora',
    '48': 'Mt Barker',
    '61': 'Munglinup',
    '23': 'Murray',
    '11': 'Narrogin',
    '49': 'Newman',
    '50': 'Norseman',
    '60': 'North Bannister',
    '12': 'Northam',
    '62': 'Northam (Shire)',
    '13': 'Port Hedland',
    '51': 'Ravensthorpe',
    '57': 'Regans Ford',
    '14': 'South Hedland',
    '53': 'Tammin',
    '24': 'Waroona',
    '54': 'Williams',
    '55': 'Wubin',
    '59': 'Wundowie',
    '56': 'York',
  };

  ///Brand display string to RSS value
  static final Map<String, String> brandsStringToRss = {
    '7-Eleven': '29',
    'Ampol': '2',
    'Better Choice': '3',
    'BOC': '4',
    'BP': '5',
    'Caltex': '6',
    'Caltex Woolworths': '19',
    'Coles Express': '20',
    'Costco': '32',
    'Eagle': '24',
    'FastFuel 24/7': '25',
    'Gull': '7',
    'Independent': '15',
    'Kleenheat': '8',
    'Kwikfuel': '9',
    'Liberty': '10',
    'Metro Petroleum': '30',
    'Mobil': '11',
    'Peak': '13',
    'Puma': '26',
    'Shell': '14',
    'United': '23',
    'Vibe': '27',
    'WA Fuels': '31',
    'Wesco': '16',
  };

  ///Brand RSS value to display string
  static final Map<String, String> brandsRssToString = {
    '0': 'Any Brand',
    '29': '7-Eleven',
    '2': 'Ampol',
    '3': 'Better Choice',
    '4': 'BOC',
    '5': 'BP',
    '6': 'Caltex',
    '19': 'Caltex Woolworths',
    '20': 'Coles Express',
    '32': 'Costco',
    '24': 'Eagle',
    '25': 'FastFuel 24/7',
    '7': 'Gull',
    '15': 'Independent',
    '8': 'Kleenheat',
    '9': 'Kwikfuel',
    '10': 'Liberty',
    '30': 'Metro Petroleum',
    '11': 'Mobil',
    '13': 'Peak',
    '26': 'Puma',
    '14': 'Shell',
    '23': 'United',
    '27': 'Vibe',
    '31': 'WA Fuels',
    '16': 'Wesco',
  };

  ///Suburb display string (RSS value is the same hence this is a list not a map)
  static final List<String> suburbs = [
    'ALBANY',
    'ALEXANDER HEIGHTS',
    'ALFRED COVE',
    'ALKIMOS',
    'APPLECROSS',
    'ARMADALE',
    'ASCOT',
    'ASHBY',
    'ATTADALE',
    'AUGUSTA',
    'AUSTRALIND',
    'AVELEY',
    'BAKERS HILL',
    'BALCATTA',
    'BALDIVIS',
    'BALGA',
    'BALINGUP',
    'BALLAJURA',
    'BANKSIA GROVE',
    'BARRAGUP',
    'BASKERVILLE',
    'BASSENDEAN',
    'BAYSWATER',
    'BECKENHAM',
    'BEDFORD',
    'BEDFORDALE',
    'BEECHBORO',
    'BEELIAR',
    'BELDON',
    'BELLEVUE',
    'BELMONT',
    'BENTLEY',
    'BERTRAM',
    'BIBRA LAKE',
    'BICTON',
    'BINNINGUP',
    'BOORAGOON',
    'BOULDER',
    'BOYANUP',
    'BRENTWOOD',
    'BRIDGETOWN',
    'BROADWATER',
    'BROOME',
    'BRUNSWICK',
    'BULL CREEK',
    'BULLSBROOK',
    'BUNBURY',
    'BURSWOOD',
    'BUSSELTON',
    'BUTLER',
    'BYFORD',
    'CALISTA',
    'CANNING VALE',
    'CANNINGTON',
    'CAPEL',
    'CARBUNUP RIVER',
    'CARINE',
    'CARLISLE',
    'CARNARVON',
    'CATABY',
    'CAVERSHAM',
    'CHIDLOW',
    'CLAREMONT',
    'CLARKSON',
    'CLOVERDALE',
    'COCKBURN CENTRAL',
    'COLLIE',
    'COMO',
    'COOLGARDIE',
    'COOLUP',
    'COWARAMUP',
    'CUNDERDIN',
    'CURRAMBINE',
    'DALWALLINU',
    'DAMPIER',
    'DARDANUP',
    'DAWESVILLE',
    'DAYTON',
    'DENMARK',
    'DERBY',
    'DIANELLA',
    'DONGARA',
    'DONNYBROOK',
    'DOUBLEVIEW',
    'DUNCRAIG',
    'DUNSBOROUGH',
    'DWELLINGUP',
    'EAST FREMANTLE',
    'EAST PERTH',
    'EAST ROCKINGHAM',
    'EAST VICTORIA PARK',
    'EATON',
    'EDGEWATER',
    'ELLENBROOK',
    'EMBLETON',
    'ERSKINE',
    'ESPERANCE',
    'EXMOUTH',
    'FALCON',
    'FITZROY CROSSING',
    'FLOREAT',
    'FORRESTDALE',
    'FORRESTFIELD',
    'FREMANTLE',
    'GELORUP',
    'GERALDTON',
    'GIDGEGANNUP',
    'GIRRAWHEEN',
    'GLEN FORREST',
    'GLEN IRIS',
    'GLENDALOUGH',
    'GLENFIELD',
    'GOSNELLS',
    'GRACETOWN',
    'GREENBUSHES',
    'GREENFIELDS',
    'GREENOUGH',
    'GREENWOOD',
    'GUILDFORD',
    'GWELUP',
    'HALLS HEAD',
    'HAMILTON HILL',
    'HARRISDALE',
    'HARVEY',
    'HENDERSON',
    'HENLEY BROOK',
    'HERNE HILL',
    'HIGH WYCOMBE',
    'HILLARYS',
    'HUNTINGDALE',
    'INNALOO',
    'JANDAKOT',
    'JARRAHDALE',
    'JINDALEE',
    'JOLIMONT',
    'JOONDALUP',
    'JURIEN BAY',
    'KALAMUNDA',
    'KALGOORLIE',
    'KAMBALDA EAST',
    'KARAWARA',
    'KARDINYA',
    'KARNUP',
    'KARRAGULLEN',
    'KARRATHA',
    'KARRIDALE',
    'KARRINYUP',
    'KELLERBERRIN',
    'KELMSCOTT',
    'KEWDALE',
    'KIARA',
    'KINGSLEY',
    'KOJONUP',
    'KOONDOOLA',
    'KUNUNURRA',
    'KWINANA BEACH',
    'KWINANA TOWN CENTRE',
    'LAKELANDS',
    'LANDSDALE',
    'LANGFORD',
    'LEDA',
    'LEEDERVILLE',
    'LEEMING',
    'LESMURDIE',
    'LEXIA',
    'LYNWOOD',
    'MADDINGTON',
    'MADELEY',
    'MAIDA VALE',
    'MALABINE',
    'MALAGA',
    'MANDURAH',
    'MANJIMUP',
    'MANNING',
    'MANYPEAKS',
    'MARGARET RIVER',
    'MEADOW SPRINGS',
    'MECKERING',
    'MEEKATHARRA',
    'MERRIWA',
    'MIDDLE SWAN',
    'MIDLAND',
    'MIDVALE',
    'MINDARIE',
    'MIRRABOOKA',
    'MOONYOONOOKA',
    'MOORA',
    'MORLEY',
    'MOSMAN PARK',
    'MOUNT BARKER',
    'MT HELENA',
    'MT LAWLEY',
    'MT PLEASANT',
    'MULLALOO',
    'MULLEWA',
    'MUNDARING',
    'MUNDIJONG',
    'MUNGLINUP',
    'MUNSTER',
    'MURDOCH',
    'MYALUP',
    'MYAREE',
    'NARROGIN',
    'NAVAL BASE',
    'NEDLANDS',
    'NEERABUP',
    'NEWMAN',
    'NOLLAMARA',
    'NORANDA',
    'NORSEMAN',
    'NORTH BANNISTER',
    'NORTH DANDALUP',
    'NORTH FREMANTLE',
    'NORTH PERTH',
    'NORTH YUNDERUP',
    'NORTHAM',
    'NORTHBRIDGE',
    'NORTHCLIFFE',
    'NOWERGUP',
    'O\'CONNOR',
    'OCEAN REEF',
    'OSBORNE PARK',
    'PADBURY',
    'PALMYRA',
    'PEARSALL',
    'PEMBERTON',
    'PERTH',
    'PERTH AIRPORT',
    'PIARA WATERS',
    'PICTON',
    'PICTON EAST',
    'PINJARRA',
    'PORT HEDLAND',
    'PORT KENNEDY',
    'PRESTON BEACH',
    'QUEENS PARK',
    'QUINNS ROCKS',
    'RAVENSTHORPE',
    'RAVENSWOOD',
    'REDCLIFFE',
    'REGANS FORD',
    'RIDGEWOOD',
    'RIVERTON',
    'RIVERVALE',
    'ROCKINGHAM',
    'ROLEYSTONE',
    'ROSA BROOK',
    'SAFETY BAY',
    'SAWYERS VALLEY',
    'SCARBOROUGH',
    'SECRET HARBOUR',
    'SERPENTINE',
    'SEVILLE GROVE',
    'SIESTA PARK',
    'SINGLETON',
    'SORRENTO',
    'SOUTH FREMANTLE',
    'SOUTH HEDLAND',
    'SOUTH LAKE',
    'SOUTH PERTH',
    'SOUTH YUNDERUP',
    'SOUTHERN RIVER',
    'SPEARWOOD',
    'STRATHAM',
    'STRATTON',
    'SUBIACO',
    'SUCCESS',
    'SWAN VIEW',
    'SWANBOURNE',
    'TAMMIN',
    'THE LAKES',
    'THORNLIE',
    'TUART HILL',
    'UPPER SWAN',
    'VASSE',
    'VICTORIA PARK',
    'WAIKIKI',
    'WALKAWAY',
    'WALPOLE',
    'WANGARA',
    'WANNEROO',
    'WARNBRO',
    'WAROONA',
    'WARWICK',
    'WATERLOO',
    'WATTLE GROVE',
    'WEDGEFIELD',
    'WELLSTEAD',
    'WELSHPOOL',
    'WEMBLEY',
    'WEST BUSSELTON',
    'WEST KALGOORLIE',
    'WEST PERTH',
    'WEST PINJARRA',
    'WEST SWAN',
    'WESTMINSTER',
    'WILLETTON',
    'WILLIAMS',
    'WITCHCLIFFE',
    'WOODBRIDGE',
    'WOODVALE',
    'WUBIN',
    'WUNDOWIE',
    'YANCHEP',
    'YANGEBUP',
    'YOKINE',
    'YORK',
    'YOUNGS SIDING',
  ];

  ///Firebase Cloud Messaging categories
  static final String updateFuelPricesCategory = 'UpdateFuelPrices';

  ///RSS strings
  static final String productString = 'Product';
  static final String brandString = 'Brand';
  static final String regionString = 'Region';
  static final String suburbString = 'Suburb';
  static final String surroundingString = 'Surrounding';
  static final String dayString = 'Day';

  ///Database strings
  static final String dbFavourites = 'favourites';
  static final String dbProduct = 'product';
  static final String dbBrand = 'brand';
  static final String dbRegion = 'region';
  static final String dbSuburb = 'suburb';
  static final String dbIncludeSurrounding = 'include_surrounding';
  static final String dbPushNotification = 'push_notification';
  static final String dbFirstRun = 'first_run';
  static final String dbNotificationsEnabled = 'notifications';
  static final String dbLastBackgroundRun = 'last_background_run';
}

///EXAMPLE RSS ITEM:
//<item>
//   <title>128.7: United Neerabup</title>
//   <description>Address: 2038 Wanneroo Rd, NEERABUP, Phone: 0404 084 044</description>
//   <brand>United</brand>
//   <date>2021-04-25</date>
//   <price>128.7</price>
//   <trading-name>United Neerabup</trading-name>
//   <location>NEERABUP</location>
//   <address>2038 Wanneroo Rd</address>
//   <phone>0404 084 044</phone>
//   <latitude>-31.672434</latitude>
//   <longitude>115.743141</longitude>
//   <site-features>, </site-features>
//</item>
