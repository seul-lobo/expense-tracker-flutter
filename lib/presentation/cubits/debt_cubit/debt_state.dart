part of 'debt_cubit.dart';

abstract class DebtState extends Equatable {
  const DebtState();

  @override
  List<Object?> get props => [];
}

class DebtInitial extends DebtState {}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  final List<DebtEntity> debts;

  const DebtLoaded(this.debts);

  @override
  List<Object?> get props => [debts];
}

class DebtSuccess extends DebtState {
  final String message;

  const DebtSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DebtError extends DebtState {
  final String message;

  const DebtError(this.message);

  @override
  List<Object?> get props => [message];
}
