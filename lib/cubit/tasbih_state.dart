import 'package:equatable/equatable.dart';

class TasbihState extends Equatable {
  final int count;
  final int laps;
  final int target;

  const TasbihState({this.count = 0, this.laps = 0, this.target = 33});

  TasbihState copyWith({int? count, int? laps, int? target}) {
    return TasbihState(
      count: count ?? this.count,
      laps: laps ?? this.laps,
      target: target ?? this.target,
    );
  }

  @override
  List<Object?> get props => [count, laps, target];
}
