part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistEvent {}

final class WishlistSubscribeRequested extends WishlistEvent {}

final class WishlistAddRequested extends WishlistEvent {
  final String itemId;

  WishlistAddRequested({required this.itemId});
}

final class WishlistRemoveRequested extends WishlistEvent {
  final String itemId;

  WishlistRemoveRequested({required this.itemId});
}
