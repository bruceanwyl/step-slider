import 'package:quiver/core.dart';
import 'package:step_slider/step_slider.dart';

class SnapMode {
  const SnapMode._(this._snapper, this._name);

  SnapMode.value(double value) : this._(ValueSnapper(value), 'value');
  SnapMode.percent(double percent) : this._(PercentSnapper(percent), 'percent');
  SnapMode.stretch() : this._(StretchSnapper(), 'stretch');

  final Snapper _snapper;
  final String _name;

  @override
  String toString() => '$SnapMode.$_name';

  @override
  bool operator ==(o) =>
      o != null &&
      o is SnapMode &&
      o._name == this._name &&
      o._snapper == this._snapper;

  @override
  int get hashCode => hash2(_name, _snapper);

  Snapper snapperFor(List<double> items, double min, double max) =>
      _snapper..config = SnapperConfig(items, min, max);
}
