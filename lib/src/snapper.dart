import 'dart:math';

import 'package:quiver_hashcode/hashcode.dart';

abstract class Snapper {
  SnapperConfig _config;
  set config(SnapperConfig value) {
    _config = value;
    _boundsMap = null;
  }

  List<double> _getBoundsList();

  double snap(double value) => (_boundsMap ??= _getBoundsMap())
      .entries
      .firstWhere((it) => it.value.contains(value), orElse: () => null)
      ?.key;

  Map<double, Range> _boundsMap;
  Map<double, Range> _getBoundsMap() {
    final boundsMap = <double, Range>{};
    final boundsList = _getBoundsList();
    var index = 0;
    _config.items.forEach((it) {
      boundsMap[it] = Range(boundsList[2 * index], boundsList[2 * index + 1]);
      ++index;
    });
    return boundsMap;
  }

  List<double> _getBoundsForDelta(double delta) {
    final bounds = <double>[];
    bounds.add(max(_config.min, _config.items.first - delta));
    _config.items.reduce((a, b) {
      var rangeA = a + delta;
      var rangeB = b - delta;
      if (rangeA > rangeB) {
        rangeA = (rangeA + rangeB) / 2;
        rangeB = rangeA;
      }
      bounds..add(rangeA)..add(rangeB);
      return b;
    });
    bounds.add(min(_config.max, _config.items.last + delta));
    return bounds;
  }

  @override
  bool operator ==(o) => o != null && o is Snapper && o._config == this._config;

  @override
  int get hashCode => _config.hashCode;
}

class ValueSnapper extends Snapper {
  ValueSnapper(this.value);

  final double value;

  List<double> _getBoundsList() => _getBoundsForDelta(value);

  @override
  bool operator ==(o) =>
      o != null && o is ValueSnapper && o.value == this.value;

  @override
  int get hashCode => value.hashCode;
}

class PercentSnapper extends Snapper {
  PercentSnapper(this.percent);

  final double percent;

  @override
  List<double> _getBoundsList() =>
      _getBoundsForDelta((_config.max - _config.min) * percent);

  @override
  bool operator ==(o) =>
      o != null && o is PercentSnapper && o.percent == this.percent;

  @override
  int get hashCode => percent.hashCode;
}

class StretchSnapper extends Snapper {
  List<double> _getBoundsList() {
    final bounds = <double>[];
    bounds.add(_config.min);
    _config.items.reduce((a, b) {
      final range = (a + b) / 2;
      bounds..add(range)..add(range);
      return b;
    });
    bounds.add(_config.max);
    return bounds;
  }

  @override
  bool operator ==(o) => o != null && o is StretchSnapper;

  @override
  int get hashCode => super.hashCode;
}

class SnapperConfig {
  SnapperConfig(this.items, this.min, this.max);
  final List<double> items;
  final double min;
  final double max;

  @override
  bool operator ==(o) =>
      o != null &&
      o is SnapperConfig &&
      o.items == this.items &&
      o.min == this.min &&
      o.max == this.max;

  @override
  int get hashCode => hash3(items, min, max);
}

class Range {
  Range(this.begin, this.end);
  final double begin;
  final double end;
  bool contains(double value) => value >= begin && value <= end;
}
