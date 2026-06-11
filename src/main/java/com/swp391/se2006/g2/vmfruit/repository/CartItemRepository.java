package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Integer> {

    List<CartItem> findByCart_User_Email(String email);
    List<CartItem> findByCart_CartId(Integer cartId);
    Optional<CartItem>  findByCart_CartIdAndProduct_ProductId(Integer cartId, Integer productId);
    long countByCart_CartId(Integer cartId);
    void deleteByCart_CartId(Integer cartId);
}