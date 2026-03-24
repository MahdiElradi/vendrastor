import '../../../../features/auth/domain/entities/user_entity.dart';

class ProfileState {
  const ProfileState({
    this.user,
    this.isLoading = false,
    this.isUpdating = false,
    this.errorMessage,
    this.successMessage,
  });

  final UserEntity? user;
  final bool isLoading;
  final bool isUpdating;
  final String? errorMessage;
  final String? successMessage;

  ProfileState copyWith({
    UserEntity? user,
    bool? isLoading,
    bool? isUpdating,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileState &&
          user == other.user &&
          isLoading == other.isLoading &&
          isUpdating == other.isUpdating &&
          errorMessage == other.errorMessage &&
          successMessage == other.successMessage;

  @override
  int get hashCode =>
      Object.hash(user, isLoading, isUpdating, errorMessage, successMessage);
}
