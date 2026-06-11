package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.response.CartItemResponse;
import com.swp391.se2006.g2.vmfruit.entity.Cart;
import com.swp391.se2006.g2.vmfruit.entity.CartItem;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.repository.CartItemRepository;
import com.swp391.se2006.g2.vmfruit.repository.CartRepository;
import com.swp391.se2006.g2.vmfruit.repository.ProductRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRepository;
import com.swp391.se2006.g2.vmfruit.service.CartService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CartServiceImpl implements CartService {

    private final CartItemRepository cartItemRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final CartRepository cartRepository;

    public CartServiceImpl(CartItemRepository cartItemRepository,
                           ProductRepository productRepository,
                           UserRepository userRepository,
                           CartRepository cartRepository) {
        this.cartItemRepository = cartItemRepository;
        this.productRepository = productRepository;
        this.userRepository = userRepository;
        this.cartRepository = cartRepository;
    }

    @Transactional
    @Override
    public void addProductToCart(String email, Integer productId, BigDecimal quantity) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));
        addToCart(user.getUserId(), productId, quantity);
    }

    @Transactional
    @Override
    public void addToCart(Integer userId, Integer productId, BigDecimal quantity) {
        Cart cart = getCartByUserId(userId);
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Sản phẩm không tồn tại"));

        Optional<CartItem> existingItem = cartItemRepository
                . findByCart_CartIdAndProduct_ProductId(cart.getCartId(), productId);

        if (existingItem.isPresent()) {
            CartItem item = existingItem.get();
            item.setQuantity(item.getQuantity().add(quantity));
            cartItemRepository.save(item);
        } else {
            CartItem cartItem = new CartItem();
            cartItem.setCart(cart);
            cartItem.setProduct(product);
            cartItem.setQuantity(quantity);
            cartItem.setUnitPrice(product.getBasePrice());
            cartItem.setCreatedAt(LocalDateTime.now());
            cartItemRepository.save(cartItem);
        }

        cart.setUpdatedAt(LocalDateTime.now());
        cartRepository.save(cart);
    }

    @Override
    public List<CartItemResponse> getCartItemsByEmail(String email) {
        return cartItemRepository.findByCart_User_Email(email).stream().map(item -> {
            CartItemResponse dto = new CartItemResponse();
            dto.setCartItemId(item.getCartItemId());
            dto.setProductName(item.getProduct().getProductName());
            dto.setImageUrl(item.getProduct().getImageUrl());   // thêm mới
            dto.setUnit(item.getProduct().getUnit());           // thêm mới
            dto.setQuantity(item.getQuantity());
            dto.setUnitPrice(item.getUnitPrice());
            dto.setSubtotal(item.getUnitPrice().multiply(item.getQuantity()));
            return dto;
        }).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void removeCartItem(Integer cartItemId) {
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("Sản phẩm trong giỏ không tồn tại"));
        cartItemRepository.delete(cartItem);
    }

    @Override
    public Cart getCartByUserId(Integer userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));
        return cartRepository.findByUser_UserId(userId).orElseGet(() -> {
            Cart newCart = new Cart();
            newCart.setUser(user);
            newCart.setCreatedAt(LocalDateTime.now());
            return cartRepository.save(newCart);
        });
    }

    @Override
    public List<CartItem> getCartItems(Integer userId) {
        Cart cart = getCartByUserId(userId);
        return cartItemRepository.findByCart_CartId(cart.getCartId());
    }

    @Override
    @Transactional
    public void updateQuantity(Integer cartItemId, BigDecimal quantity) {
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("Sản phẩm trong giỏ không tồn tại"));
        if (quantity.compareTo(BigDecimal.ZERO) <= 0) {
            removeCartItem(cartItemId);
        } else {
            cartItem.setQuantity(quantity);
            cartItemRepository.save(cartItem);
        }
    }

    @Override
    public BigDecimal getCartTotal(Integer userId) {
        return getCartItems(userId).stream()
                .map(item -> item.getUnitPrice().multiply(item.getQuantity()))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public long countCartItems(Integer userId) {
        Cart cart = getCartByUserId(userId);
        return cartItemRepository.countByCart_CartId(cart.getCartId());
    }
}