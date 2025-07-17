part of 'account_cubit.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final List<AccountEntity> accounts;

  const AccountLoaded(this.accounts);

  @override
  List<Object> get props => [accounts];
}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);

  @override
  List<Object> get props => [message];
}
