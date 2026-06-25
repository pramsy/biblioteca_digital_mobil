import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class UserConflictFailure extends Failure {
  const UserConflictFailure(super.message);
}

class BookUnavailableFailure extends Failure {
  const BookUnavailableFailure(super.message);
}

class BookLockedFailure extends Failure {
  const BookLockedFailure(super.message);
}
