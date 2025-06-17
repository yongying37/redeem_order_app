part of 'cart_bloc.dart';

sealed class CartEvent {
  const CartEvent();
}

class AddItem extends CartEvent {
  final CartItem item;
  const AddItem(this.item);
}

class RemoveItem extends CartEvent {
  final String id;
  const RemoveItem(this.id);
}

class ClearCart extends CartEvent {}

class UpdateItemQuantity extends CartEvent {
  final String id;
  final int newQuantity;
  UpdateItemQuantity(this.id, this.newQuantity);
}

class RedeemPoints extends CartEvent {
  final int points;
  const RedeemPoints(this.points);
}