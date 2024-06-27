
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_manager/pokemon_manager.dart';

class StatChart extends StatelessWidget {
  const StatChart({super.key, required this.base, required this.iv, required this.ev});
  final Stats base;
  final Stats iv;
  final Stats ev;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: RadarChart(
          RadarChartData(
              getTitle: (index, angle) {
              const usedAngle = 0.0;
              switch (index) {
                case 0:
                  return const RadarChartTitle(
                    text: 'HP',
                    angle: usedAngle,
                  );
                case 1:
                  return const RadarChartTitle(
                    text: 'Attack',
                    angle: usedAngle,
                  );
                case 2:
                  return const RadarChartTitle(text: 'Defense', angle: usedAngle);
                case 3:
                  return const RadarChartTitle(text: 'Speed', angle: usedAngle);
                case 4:
                  return const RadarChartTitle(text: 'Special Attack', angle: usedAngle);
                case 5:
                  return const RadarChartTitle(text: 'Special Defense', angle: usedAngle);
                default:
                  return const RadarChartTitle(text: '');
              }
            }, 
            dataSets: getDataSets(),
            radarShape: RadarShape.polygon,
            radarBorderData: const BorderSide(color: Colors.blue, width: 2),
            radarBackgroundColor: Colors.transparent,
            radarTouchData: RadarTouchData(touchCallback: null),
            borderData: FlBorderData(show: false),
          )
        ),
      ),
    );
  }

  List<RadarDataSet> getDataSets() {
    List<RadarDataSet> dataSets = [];
    dataSets.add(RadarDataSet(
        dataEntries: [
          RadarEntry(value: base.hp * 1.0),
          RadarEntry(value: base.attack * 1.0),
          RadarEntry(value: base.defense * 1.0),
          RadarEntry(value: base.speed * 1.0),
          RadarEntry(value: base.specialAttack * 1.0),
          RadarEntry(value: base.specialDefense * 1.0),
        ],
        fillColor: Colors.blue.shade500.withOpacity(0.5),
        borderColor: Colors.blue.shade500,
        entryRadius: 1));

    dataSets.add(RadarDataSet(
        dataEntries: [
          RadarEntry(value: (base.hp * 1.0)+((iv.hp * 1.0 / 32.0) * 255.0) * 1.2),
          RadarEntry(value: (base.attack * 1.0)+((iv.attack * 1.0 / 32.0) * 255.0) * 1.2),
          RadarEntry(value: (base.defense * 1.0)+((iv.defense * 1.0 / 32.0) * 255.0) * 1.2),
          RadarEntry(value: (base.speed * 1.0)+((iv.speed * 1.0 / 32.0) * 255.0) * 1.2),
          RadarEntry(value: (base.specialAttack * 1.0)+((iv.specialAttack * 1.0 / 32.0) * 255.0) * 1.2),
          RadarEntry(value: (base.specialDefense * 1.0)+((iv.specialDefense * 1.0 / 32.0) * 255.0) * 1.2),
        ],
        fillColor: Colors.teal.shade500.withOpacity(0.5),
        borderColor: Colors.teal.shade500,
        entryRadius: 1));

    dataSets.add(RadarDataSet(
        dataEntries: [
          RadarEntry(value: (base.hp * 1.0)+((iv.hp * 1.0 / 32.0) * 255.0)+(ev.hp * 1.0) * 2),
          RadarEntry(value: (base.attack * 1.0)+((iv.attack * 1.0 / 32.0) * 255.0)+(ev.attack * 1.0) * 2),
          RadarEntry(value: (base.defense * 1.0)+((iv.defense * 1.0 / 32.0) * 255.0)+(ev.defense * 1.0) * 2),
          RadarEntry(value: (base.speed * 1.0)+((iv.speed * 1.0 / 32.0) * 255.0)+(ev.speed * 1.0) * 2),
          RadarEntry(value: (base.specialAttack * 1.0)+((iv.specialAttack * 1.0 / 32.0) * 255.0)+(ev.specialAttack * 1.0) * 2),
          RadarEntry(value: (base.specialDefense * 1.0)+((iv.specialDefense * 1.0 / 32.0) * 255.0)+(ev.specialDefense * 1.0) * 2),
        ],
        fillColor: Colors.green.shade500.withOpacity(0.5),
        borderColor: Colors.green.shade500,
        entryRadius: 1));
    return dataSets.reversed.toList();
  }
}