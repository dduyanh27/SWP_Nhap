package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.entity.CustomerAddress;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.service.CartService;
import com.swp391.se2006.g2.vmfruit.service.CustomerAddressService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    private final CartService cartService;
    private final CustomerAddressService addressService;

    public CheckoutController(CartService cartService, CustomerAddressService addressService) {
        this.cartService = cartService;
        this.addressService = addressService;
    }

    @GetMapping
    public String checkoutPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("currentUser", user);
        model.addAttribute("cartItems", cartService.getCartItemsByEmail(user.getEmail()));
        model.addAttribute("cartTotal", cartService.getCartTotal(user.getUserId()));
        model.addAttribute("cartCount", cartService.countCartItems(user.getUserId()));

        List<CustomerAddress> addresses = addressService.getAddressesByUserId(user.getUserId());
        model.addAttribute("addressList", addresses);
        addresses.stream()
                .filter(a -> Boolean.TRUE.equals(a.getIsDefault()))
                .findFirst()
                .ifPresent(addr -> model.addAttribute("defaultAddress", addr));

        return "checkout";
    }
}
