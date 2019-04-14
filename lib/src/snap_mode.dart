import 'package:step_slider/src/snapper.dart';

class SnapMode {
  const SnapMode._(this._snapper);

  SnapMode.value(double value) : this._(ValueSnapper(value));
  SnapMode.percent(double percent) : this._(PercentSnapper(percent));
  SnapMode.stretch() : this._(StretchSnapper());

  final Snapper _snapper;

  @override
  bool operator ==(o) =>
      o != null && o is SnapMode && o._snapper == this._snapper;

  @override
  int get hashCode => _snapper.hashCode;

  Snapper snapperFor(List<double> items, double min, double max) =>
      _snapper..config = SnapperConfig(items, min, max);
}
