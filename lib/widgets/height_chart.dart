import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:converter/converter.dart';
import 'package:mudkip_frontend/core/constants.dart';
import 'package:mudkip_frontend/core/settings.dart';

// ignore: must_be_immutable
class HeightIndicator extends StatefulWidget {
  HeightIndicator(
      {super.key, required this.pokemonHeight, required this.imageUrl});

  double pokemonHeight = 2;
  String imageUrl = "";

  @override
  State<HeightIndicator> createState() => _HeightIndicatorState();
}

class _HeightIndicatorState extends State<HeightIndicator> {
  static const double averageMaleHeight = 171.45;
  static const double averageFemaleHeight = 162.56;
  // static const double minHeight = 54;
  // static const double maxHeight = 272;
  static const double defaultChartHeight = 500;
  double humanHeight = 171.45;
  HeightChartGender gender = Settings.heightChartGender;
  HeightChartFormat format = Settings.heightChartFormat;

  String getHeightChartGenderImage() {
    if (gender == HeightChartGender.male) {
      return 'assets/images/artwork/male.png';
    } else {
      return 'assets/images/artwork/female.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    resetHumanHeight();
    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            // color: Colors.blue,
            child: Image.asset(
              getHeightChartGenderImage(),
              height: defaultChartHeight * calulateHumanHeight(),
              filterQuality: FilterQuality.medium,
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(
            child: Image.asset(
              widget.imageUrl,
              height: defaultChartHeight * calulatePokemonHeight(),
              fit: BoxFit.fitHeight,
              filterQuality: FilterQuality.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: defaultChartHeight,
              child: LinearGauge(
                gaugeOrientation: GaugeOrientation.vertical,
                customLabels: getCustomLabels(),
                end: 100,
                pointers: [
                  Pointer(
                    pointerAlignment: PointerAlignment.start,
                    value: calulatePokemonHeight() * 100,
                    width: 20,
                    height: 5,
                    shape: PointerShape.rectangle,
                    pointerPosition: PointerPosition.left,
                  ),
                  Pointer(
                      shape: PointerShape.rectangle,
                      value: calulateHumanHeight() * 100,
                      pointerPosition: PointerPosition.left,
                      width: 20,
                      height: 5),
                ],
                linearGaugeBoxDecoration: const LinearGaugeBoxDecoration(
                  thickness: 10,
                  borderRadius: 5,
                ),
                rulers: RulerStyle(
                  rulerPosition: RulerPosition.right,
                  textStyle: TextStyle(
                      fontSize: const TextScaler.linear(1.0).scale(16.0),
                      fontWeight: FontWeight.normal),
                  // showSecondaryRulers: false,
                ),
              ),
            ),
          ),
          // const SizedBox(width: 24),
          // SizedBox(
          //   child: Column(children: [
          //     const Text("HeightChartGender"),
          //     SegmentedButton(
          //         showSelectedIcon: false,
          //         segments: const [
          //           ButtonSegment(
          //               value: HeightChartGender.male, icon: Icon(Icons.male_rounded)),
          //           ButtonSegment(
          //               value: HeightChartGender.female,
          //               icon: Icon(Icons.female_rounded))
          //         ],
          //         selected: <HeightChartGender>{gender},
          //         onSelectionChanged: (value) {
          //           setState(() {
          //             gender = value.first;
          //             resetHumanHeight();
          //           });
          //         }),
          //     const SizedBox(height: 24),
          //     const Text("Height"),
          //     SegmentedButton(
          //         showSelectedIcon: false,
          //         segments: const [
          //           ButtonSegment(
          //             value: HeightChartFormat.metric,
          //             label: Text("Metric"),
          //           ),
          //           ButtonSegment(
          //             value: HeightChartFormat.imperial,
          //             label: Text("Imperial"),
          //           ),
          //         ],
          //         selected: <HeightChartFormat>{format},
          //         onSelectionChanged: (value) {
          //           setState(() {
          //             format = value.first;
          //           });
          //         }),
          //   ]),
          // ),
        ],
      ),
    );
  }

  List<CustomRulerLabel> getCustomLabels() {
    List<CustomRulerLabel> labels = [
      CustomRulerLabel(
          text: formatLabel(Length(humanHeight, "cm")),
          value: calulateHumanHeight() * 100),
      CustomRulerLabel(
          text: formatLabel(Length(widget.pokemonHeight, "dm")),
          value: calulatePokemonHeight() * 100),
      CustomRulerLabel(text: formatLabel(Length(0, "cm")), value: 0),
    ];
    labels.sort((a, b) => a.value!.compareTo(b.value as num));
    return labels;
  }

  double calulateHumanHeight() {
    return clampDouble(
        humanHeight /
            Length(widget.pokemonHeight, "dm").valueIn("cm").toDouble(),
        0,
        1);
  }

  double calulatePokemonHeight() {
    return clampDouble(
        Length(widget.pokemonHeight, "dm").valueIn("cm").toDouble() /
            humanHeight,
        0,
        1);
  }

  void resetHumanHeight() {
    if (gender == HeightChartGender.male) {
      humanHeight = averageMaleHeight;
    } else {
      humanHeight = averageFemaleHeight;
    }
  }

  String formatLabel(Length height) {
    if (format == HeightChartFormat.imperial) {
      return "${height.valueIn("ft").truncate()}' ${Length(height.valueIn("ft") - height.valueIn("ft").truncate(), "ft").valueIn("in").truncate()}\" ft";
    }
    if (format == HeightChartFormat.metric) {
      if (height.valueIn("m") < 1) {
        return "${height.valueIn("cm").truncate()} cm";
      }
      return "${height.valueIn("m").toStringAsFixed(2)} m";
    }
    return "";
  }
}
