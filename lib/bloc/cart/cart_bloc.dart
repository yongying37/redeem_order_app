import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddItem>((event, emit) {
      final existingIndex = state.cartItems.indexWhere((cartItem) => cartItem.id == event.item.id);
      if (existingIndex != -1) {
        final updatedItems = List<CartItem>.from(state.cartItems);
        final existingItem = updatedItems[existingIndex];
        updatedItems[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity + 1);
        emit(state.copyWith(cartItems: updatedItems));
      } else {
        emit(state.copyWith(cartItems: [...state.cartItems, event.item]));
      }
    });

    on<RemoveItem>((event, emit) {
      final updatedItems = state.cartItems.where((item) => item.id != event.id).toList();
      emit(state.copyWith(cartItems: updatedItems));
    });

    on<UpdateItemQuantity>((event, emit) {
      final updatedItems = state.cartItems.map((item) {
        if (item.id == event.id) {
          return item.copyWith(quantity: event.newQuantity);
        }
        return item;
      }).toList();
      emit(state.copyWith(cartItems: updatedItems));
    });

    on<ClearCart>((event, emit) {
      emit(state.copyWith(cartItems: []));
    });

    on<RedeemPoints>((event, emit) {
      emit(state.copyWith(pointsUsed: event.points));
    });

  }
}