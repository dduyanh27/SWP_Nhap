package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.response.CartItemResponse;
import com.swp391.se2006.g2.vmfruit.entity.Cart;
import com.swp391.se2006.g2.vmfruit.entity.CartItem;

import java.math.BigDecimal;
import java.util.List;

public interface CartService {

    void addProductToCart(String email, Integer productId, BigDecimal quantity);
    void addToCart(Integer userId, Integer productId, BigDecimal quantity);

    List<CartItemResponse> getCartItemsByEmail(String email);

    void removeCartItem(Integer cartItemId);

    Cart getCartByUserId(Integer userId);

    List<CartItem> getCartItems(Integer userId);

    void updateQuantity(Integer cartItemId, BigDecimal quantity);

    BigDecimal getCartTotal(Integer userId);

    long countCartItems(Integer userId);
}