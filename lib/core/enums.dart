import 'dart:io';

// ignore_for_file: constant_identifier_names

/// # CompatibleFiles
/// ## A class that contains the extensions of the compatible files.
/// ### Compatible Extensions:
/// - pk6 (A Single Pokémon + Basic Trainer Info)
/// ### Planned Compatible Extensions:
/// - pk1 (A Single Pokémon + Basic Trainer Info)
/// - pk2 (A Single Pokémon + Basic Trainer Info)
/// - pk3 (A Single Pokémon + Basic Trainer Info)
/// - pk4 (A Single Pokémon + Basic Trainer Info)
/// - pk5 (A Single Pokémon + Basic Trainer Info)
/// - pk7 (A Single Pokémon + Basic Trainer Info)
/// - pk8 (A Single Pokémon + Basic Trainer Info)
/// - pk9 (A Single Pokémon + Basic Trainer Info)
/// - sav (Trainer Data + All Their Pokémon)
/// - json (A Single Pokémon + Basic Trainer Info, or Trainer Data + All Their Pokémons. Requires JSON export to be implemented.)
/// - db (All Pokémon Manager Data. Requires DB export to be implemented.)
final class CompatibleFiles {
  static const List<String> compatibleExtensions = [
    "pk6",
  ];

  static bool isCompatibleFile(File file) {
    if(compatibleExtensions.contains(file.path.split('.').last)){
      return true;
    }
    return false;
  }
}

/// # Elements
/// ## A class that contains the ids of elements of the games. TODO: Figure out if this is necessary.
/// ### Constants:
/// - None
/// - Normal
/// - Fire
/// - Water
/// - Electric
/// - Grass
/// - Ice
/// - Fighting
/// - Poison
/// - Ground
/// - Flying
/// - Psychic
/// - Bug
/// - Rock
/// - Ghost
/// - Dragon
/// - Dark
/// - Steel
/// - Fairy
final class Elements{
  static const int none = 0;
  static const int normal = 1;
  static const int fire = 2;
  static const int water = 3;
  static const int electric = 4;
  static const int grass = 5;
  static const int ice = 6;
  static const int fighting = 7;
  static const int poison = 8;
  static const int ground = 9;
  static const int flying = 10;
  static const int psychic = 11;
  static const int bug = 12;
  static const int rock = 13;
  static const int ghost = 14;
  static const int dragon = 15;
  static const int dark = 16;
  static const int steel = 17;
  static const int fairy = 18;

  String getElementName(int element) {
    switch (element) {
      case normal:
        return 'Normal';
      case fire:
        return 'Fire';
      case water:
        return 'Water';
      case electric:
        return 'Electric';
      case grass:
        return 'Grass';
      case ice:
        return 'Ice';
      case fighting:
        return 'Fighting';
      case poison:
        return 'Poison';
      case ground:
        return 'Ground';
      case flying:
        return 'Flying';
      case psychic:
        return 'Psychic';
      case bug:
        return 'Bug';
      case rock:
        return 'Rock';
      case ghost:
        return 'Ghost';
      case dragon:
        return 'Dragon';
      case dark:
        return 'Dark';
      case steel:
        return 'Steel';
      case fairy:
        return 'Fairy';
    }
    return 'Unknown';
  }
}

/// # Gender
/// ## A class that contains the possible genders from the games. 
/// ### Constants:
/// - Male
/// - Female
/// - Genderless
final class Gender {
  static const int male = 0;
  static const int female = 1;
  static const int genderless = 2;

  String getGenderName(int gender) {
    switch (gender) {
      case male:
        return 'Male';
      case female:
        return 'Female';
      case genderless:
        return 'Genderless';
    }
    return 'Unknown';
  }
}

/// # GameIDs
/// ## The IDs for each game in the Pokémon series.
/// 
/// The class has static constants for each game, each with a unique abreviation.
/// ### Abreviation Scheme:
/// 
/// The starting from the first game in the series, we can just use the first letter of the game:
///   ```md
///   Pokémon Red  
///           ^  
///   The abreviation is R. 
///   ```
/// 
/// 
/// For games that have two words in the name, we can use the first letter of each word:  
///   ```md
///   Pokémon FireRed  
///           ^   ^  
///   The abreviation is FR. 
///   ```
/// 
/// 
/// This works for most games in the Pokémon series, but there are some exceptions.
/// Lets look at Pokémon Red and Ruby for example. They both start with R, and we cannot have two games with the same abreviation.
/// So, lets use the last letter of the name as part of the abreviation:    
///   ```md
///   Pokémon Ruby  
///           ^  ^  
///   The abreviation is Ry.
///   ```
/// This also works for games with a number in the name.
///   ```md
///   Pokémon White 2
///           ^     ^
///   The abreviation is W2.
///   ```
/// 
/// With these rules, we can define the abreviation for every game in the Pokémon series.
/// However, to future-proof our code, we can define one last rule for abreviations.
/// For games that have two words in the name and have the same as another game, we can use the last letter of each word as part of the abreviation:  
///   ```md
///   Pokémon LeafGreen
///           ^  ^^   ^  
///   The abreviation is LfGn.
///   ```
/// If there are absolutly no more possible abreviations, we can use the common abreviation of the console they were released on in all lowercase:
///   ```md
///   Pokémon Scarlet Switch
///           ^     ^ ^^
///   The abreviation is Stsw.
///   Pokémon FireRed Gameboy Advance
///           ^   ^   ^   ^   ^
///   The abreviation is FRgba.
///   ```
/// 
///  ### Constants:
///  - S for Pokémon Sapphire
///  - Ry for Pokémon Ruby
///  - E for Pokémon Emerald
///  - FR for Pokémon FireRed
///  - LG for Pokémon LeafGreen
///  - D for Pokémon Diamond
///  - P for Pokémon Pearl
///  - Pt for Pokémon Platinum
///  - HG for Pokémon HeartGold
///  - SS for Pokémon SoulSilver
///  - W for Pokémon White
///  - B for Pokémon Black
///  - W2 for Pokémon White 2
///  - B2 for Pokémon Black 2
///  - X for Pokémon X
///  - Y for Pokémon Y
///  - AS for Pokémon Alpha Sapphire
///  - OR for Pokémon Omega Ruby
///  - Sn for Pokémon Sun
///  - Mn for Pokémon Moon
///  - US for Pokémon Ultra Sun
///  - UM for Pokémon Ultra Moon
final class GameIDs {
  static const int S = 1; // Pokémon Sapphire (GBA)
  static const int Ry = 2; // Pokémon Ruby (GBA)
  static const int E = 3; // Pokémon Emerald (GBA)
  static const int FR = 4; // Pokémon FireRed (GBA)
  static const int LG = 5; // Pokémon LeafGreen (GBA)
  static const int D = 10; // Pokémon Diamond (NDS)
  static const int P = 11; // Pokémon Pearl (NDS)
  static const int Pt = 12; // Pokémon Platinum (NDS)
  static const int HG = 7; // Pokémon HeartGold (NDS)
  static const int SS = 8; // Pokémon SoulSilver (NDS)
  static const int W = 20; // Pokémon White (NDS)
  static const int B = 21; // Pokémon Black (NDS)
  static const int W2 = 22; // Pokémon White 2 (NDS)
  static const int B2 = 23; // Pokémon Black 2 (NDS)
  static const int X = 24; // Pokémon X (3DS)
  static const int Y = 25; // Pokémon Y (3DS)
  static const int AS = 26; // Pokémon Alpha Sapphire (3DS)
  static const int OR = 27; // Pokémon Omega Ruby (3DS)
  static const int Sn = 30; // Pokémon Sun (3DS)
  static const int Mn = 31; // Pokémon Moon (3DS)
  static const int US = 32; // Pokémon Ultra Sun (3DS)
  static const int UM = 33; // Pokémon Ultra Moon (3DS)

} 

abstract class LevelProgression {
  static const List<int> expRequiredForNextLevel = [
  ];
  int getLevel(int exp){
    int expRequired = 0;
    for(int i = 0; i < expRequiredForNextLevel.length; i++){
      expRequired += expRequiredForNextLevel[i];
      if(exp < expRequired) return i + 1;
    }
    return 1;
  }
}

class ErracticProgression extends LevelProgression {
  static const List<int> expRequiredForNextLevel = [
    15,   
		37,
		70,    
		115,
		169,
		231,
		305,
		384,
		474,
		569,
		672,
		781,
		897,
		1018,
		1144,
		1274,
		1409,
		1547,
		1689,
		1832,
		1978,
		2127,
		2275,
		2425,
		2575,
		2725,
		2873,
		3022,
		3168,
		3311,
		3453,
		3591,
		3726,
		3856,
		3982,
		4103,
		4219,
		4328,
		4431,
		4526,
		4616,
		4695,
		4769,
		4831,
		4885,
		4930,
		4963,
		4986,
		4999,
		6324,
		6471,
		6615,
		6755,
		6891,
		7023,
		7150,
		7274,
		7391,
		7506,
		7613,
		7715,
		7812,
		7903,
		7988,
		8065,
		8137,
		8201,
		9572,
		9052,
		9870,
		10030,
		9409,
		10307,
		10457,
		9724,
		10710,
		10847,
		9995,
		11073,
		11197,
		10216,
		11393,
		11504,
		10382,
		11667,
		11762,
		10488,
		11889,
		11968,
		10532,
		12056,
		12115,
		10508,
		12163,
		12202,
		10411,
		12206,
		8343,
		8118
  ];
}

class FastProgression extends LevelProgression {
  static const List<int> expRequiredForNextLevel = [
    6,
		15, 
		30,  
		49, 
		72,
		102, 
		135, 
		174, 
		217, 
		264, 
		318, 
		375, 
		438, 
		505, 
		576, 
		654, 
		735, 
		822, 
		913, 
		1008,
		1110,
		1215,
		1326,
		1441,
		1560,
		1686,
		1815,
		1950,
		2089,
		2232,
		2382,
		2535,
		2694,
		2857,
		3024,
		3198,
		3375,
		3558,
		3745,
		3936,
		4134,
		4335,
		4542,
		4753,
		4968,
		5190,
		5415,
		5646,
		5881,
		6120,
		6366,
		6615,
		6870,
		7129,
		7392,
		7662,
		7935,
		8214,
		8497,
		8784,
		9078,
		9375,
		9678,
		9985,
		10296,
		10614,
		10935,
		11262,
		11593,
		11928,
		12270,
		12615,
		12966,
		13321,
		13680,
		14046,
		14415,
		14790,
		15169,
		15552,
		15942,
		16335,
		16734,
		17137,
		17544,
		17958,
		18375,
		18798,
		19225,
		19656,
		20094,
		20535,
		20982,
		21433,
		21888,
		22350,
		22815,
		23286,
		23761
  ];
}

class MediumFastProgression extends LevelProgression {
  static const List<int> expRequiredForNextLevel = [
    8,
    19,
		37,  
		61,  
		91,  
		127,  
		169,  
		217,
		271,
		331,
		397,
		469,
		547,
		631,
		721,
		817,
		919,
		1027,
		1141,
		1261,
		1387,
		1519,
		1657,
		1801,
		1951,
		2107,
		2269,
		2437,
		2611,
		2791,
		2977,
		3169,
		3367,
		3571,
		3781,
		3997,
		4219,
		4447,
		4681,
		4921,
		5167,
		5419,
		5677,
		5941,
		6211,
		6487,
		6769,
		7057,
		7351,
		7651,
		7957,
		8269,
		8587,
		8911,
		9241,
		9577,
		9919,
		10267,
		10621,
		10981,
		11347,
		11719,
		12097,
		12481,
		12871,
		13267,
		13669,
		14077,
		14491,
		14911,
		15337,
		15769,
		16207,
		16651,
		17101,
		17557,
		18019,
		18487,
		18961,
		19441,
		19927,
		20419,
		20917,
		21421,
		21931,
		22447,
		22969,
		23497,
		24031,
		24571,
		25117,
		25669,
		26227,
		26791,
		27361,
		27937,
		28519,
		29107,
		29701
  ];
}

class MediumProgression extends LevelProgression {
  static const List<int> expRequiredForNextLevel = [
    8,    
		19,
		37,  
		61,  
		91,  
		127,  
		169,  
		217,
		271,
		331,
		397,
		469,
		547,
		631,
		721,
		817,
		919,
		1027,
		1141,
		1261,
		1387,
		1519,
		1657,
		1801,
		1951,
		2107,
		2269,
		2437,
		2611,
		2791,
		2977,
		3169,
		3367,
		3571,
		3781,
		3997,
		4219,
		4447,
		4681,
		4921,
		5167,
		5419,
		5677,
		5941,
		6211,
		6487,
		6769,
		7057,
		7351,
		7651,
		7957,
		8269,
		8587,
		8911,
		9241,
		9577,
		9919,
		10267,
		10621,
		10981,
		11347,
		11719,
		12097,
		12481,
		12871,
		13267,
		13669,
		14077,
		14491,
		14911,
		15337,
		15769,
		16207,
		16651,
		17101,
		17557,
		18019,
		18487,
		18961,
		19441,
		19927,
		20419,
		20917,
		21421,
		21931,
		22447,
		22969,
		23497,
		24031,
		24571,
		25117,
		25669,
		26227,
		26791,
		27361,
		27937,
		28519,
		29107,
		29701
  ];
}

class MediumSlowProgression extends LevelProgression {
  static const List<int> expRequiredForNextLevel = [
		9,	  
		48,
		39,
		39,
		44,
		57,
		78,
		105,
		141,
		182,
		231,
		288,
		351,
		423,
		500,
		585,
		678,
		777,
		885,
		998,
		1119,
		1248,
		1383,
		1527,
		1676,
		1833,
		1998,
		2169,
		2349,
		2534,
		2727,
		2928,
		3135,
		3351,
		3572,
		3801,
		4038,
		4281,
		4533,
		4790,
		5055,
		5328,
		5607,
		5895,
		6188,
		6489,
		6798,
		7113,
		7437,
		7766,
		8103,
		8448,
		8799,
		9159,
		9524,
		9897,
		10278,
		10665,
		11061,
		11462,
		11871,
		12288,
		12711,
		13143,
		13580,
		14025,
		14478,
		14937,
		15405,
		15878,
		16359,
		16848,
		17343,
		17847,
		18356,
		18873,
		19398,
		19929,
		20469,
		21014,
		21567,
		22128,
		22695,
		23271,
		23852,
		24441,
		25038,
		25641,
		26253,
		26870,
		27495,
		28128,
		28767,
		29415,
		30068,
		30729,
		31398,
		32073,
		32757
  ];
}

class SlowProgression extends LevelProgression {
  static const List<int> expRequiredForNextLevel = [
    		10,
		23,
		47,
		76,
		114,
		158,
		212,
		271,
		339,
		413,
		497,
		586,
		684,
		788,
		902,
		1021,
		1149,
		1283,
		1427,
		1576,
		1734,
		1898,
		2072,
		2251,
		2439,
		2633,
		2837,
		3046,
		3264,
		3488,
		3722,
		3961,
		4209,
		4463,
		4727,
		4996,
		5274,
		5558,
		5852,
		6151,
		6459,
		6773,
		7097,
		7426,
		7764,
		8108,
		8462,
		8821,
		9189,
		9563,
		9947,
		10336,
		10734,
		11138,
		11552,
		11971,
		12399,
		12833,
		13277,
		13726,
		14184,
		14648,
		15122,
		15601,
		16089,
		16583,
		17087,
		17596,
		18114,
		18638,
		19172,
		19711,
		20259,
		20813,
		21377,
		21946,
		22524,
		23108,
		23702,
		24301,
		24909,
		25523,
		26147,
		26776,
		27414,
		28058,
		28712,
		29371,
		30039,
		30713,
		31397,
		32086,
		32784,
		33488,
		34202,
		34921,
		35649,
		36383,
		37127
  ];
}

class FluctuatingProgression extends LevelProgression {
  static const List<int> expRequiredForNextLevel = [
    		4,
		9,
		19,
		33,
		47,
		66,
		98,
		117,
		147,
		205,
		222,
		263,
		361,
		366,
		500,
		589,
		686,
		794,
		914,
		1042,
		1184,
		1337,
		1503,
		1681,
		1873,
		2080,
		2299,
		2535,
		2786,
		3051,
		3335,
		3634,
		3951,
		4286,
		4639,
		3997,
		5316,
		4536,
		6055,
		5117,
		6856,
		5744,
		7721,
		6417,
		8654,
		7136,
		9658,
		7903,
		10734,
		8722,
		11883,
		9592,
		13110,
		10515,
		14417,
		11492,
		15805,
		12526,
		17278,
		13616,
		18837,
		14766,
		20485,
		15976,
		22224,
		17247,
		24059,
		18581,
		25989,
		19980,
		28017,
		21446,
		30146,
		22978,
		32379,
		24580,
		34717,
		26252,
		37165,
		27995,
		39722,
		29812,
		42392,
		31704,
		45179,
		33670,
		48083,
		35715,
		51108,
		37839,
		54254,
		40043,
		57526,
		42330,
		60925,
		44699,
		64455,
		47153,
		68116
  ];
}