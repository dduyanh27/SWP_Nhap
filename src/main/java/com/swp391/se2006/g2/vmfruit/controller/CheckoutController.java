package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.entity.Cart;
import com.swp391.se2006.g2.vmfruit.entity.CartItem;
import com.swp391.se2006.g2.vmfruit.entity.CustomerAddress;
import com.swp391.se2006.g2.vmfruit.entity.DiscountCode;
import com.swp391.se2006.g2.vmfruit.entity.Order;
import com.swp391.se2006.g2.vmfruit.entity.OrderItem;
import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.repository.CartItemRepository;
import com.swp391.se2006.g2.vmfruit.repository.CustomerAddressRepository;
import com.swp391.se2006.g2.vmfruit.repository.DiscountCodeRepository;
import com.swp391.se2006.g2.vmfruit.repository.OrderItemRepository;
import com.swp391.se2006.g2.vmfruit.repository.OrderRepository;
import com.swp391.se2006.g2.vmfruit.service.CartService;
import com.swp391.se2006.g2.vmfruit.service.CustomerAddressService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    private final CartService cartService;
    private final CustomerAddressService addressService;
    private final CustomerAddressRepository addressRepository;
    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final CartItemRepository cartItemRepository;
    private final DiscountCodeRepository discountCodeRepository;

    @Value("${vietqr.bank-id:MB}")
    private String vietQrBankId;

    @Value("${vietqr.account-no:0123456789}")
    private String vietQrAccountNo;

    @Value("${vietqr.account-name:VMFRUIT}")
    private String vietQrAccountName;
    private Integer addressId;

    public CheckoutController(CartService cartService,
                              CustomerAddressService addressService,
                              CustomerAddressRepository addressRepository,
                              OrderRepository orderRepository,
                              OrderItemRepository orderItemRepository,
                              CartItemRepository cartItemRepository,
                              DiscountCodeRepository discountCodeRepository) {
        this.cartService = cartService;
        this.addressService = addressService;
        this.addressRepository = addressRepository;
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
        this.cartItemRepository = cartItemRepository;
        this.discountCodeRepository = discountCodeRepository;
    }

    @GetMapping
    public String checkoutPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("currentUser", user);
        model.addAttribute("cartItems", cartService.getCartItemsByEmail(user.getEmail()));
        BigDecimal cartTotal = cartService.getCartTotal(user.getUserId());
        model.addAttribute("cartTotal", cartTotal);
        model.addAttribute("cartCount", cartService.countCartItems(user.getUserId()));
        model.addAttribute("vietQrBankId", vietQrBankId);
        model.addAttribute("vietQrAccountNo", vietQrAccountNo);
        model.addAttribute("vietQrAccountName", vietQrAccountName);
        model.addAttribute("vietQrAmount", cartTotal.setScale(0, RoundingMode.HALF_UP).toPlainString());
        model.addAttribute("vietQrInfo", "VMFRUIT " + user.getUserId());
        model.addAttribute("vietQrInfoEncoded", encode("VMFRUIT " + user.getUserId()));
        model.addAttribute("vietQrAccountNameEncoded", encode(vietQrAccountName));

        List<CustomerAddress> addresses = addressService.getAddressesByUserId(user.getUserId());
        model.addAttribute("addressList", addresses);
        addresses.stream()
                .filter(a -> Boolean.TRUE.equals(a.getIsDefault()))
                .findFirst()
                .ifPresent(addr -> model.addAttribute("defaultAddress", addr));

        return "checkout";
    }

    @GetMapping("/payment-success")
    public String paymentSuccess(@RequestParam(value = "orderId", required = false) Integer orderId,
                                 Model model,
                                 HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("orderId", orderId);
        return "payment-success";
    }

    @PostMapping
    @Transactional
    public String placeOrder(@RequestParam(name = "addressId", required = false) Integer addressId,
                             @RequestParam(name = "discountCode", required = false) String discountCode,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        List<CartItem> cartItems = cartService.getCartItems(user.getUserId());
        if (cartItems.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Gio hang dang trong, khong the dat hang.");
            return "redirect:/cart";
        }
        if (addressId == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Vui long chon dia chi giao hang truoc khi dat hang.");
            return "redirect:/checkout";
        }

        CustomerAddress orderAddress = addressRepository.findById(addressId).orElse(null);
        if (orderAddress == null || orderAddress.getUser() == null
                || !user.getUserId().equals(orderAddress.getUser().getUserId())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Dia chi giao hang khong hop le.");
            return "redirect:/checkout";
        }

        BigDecimal subtotal = cartItems.stream()
                .map(item -> item.getUnitPrice().multiply(item.getQuantity()))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        LocalDateTime now = LocalDateTime.now();

        BigDecimal totalAmount = subtotal;
        DiscountCode appliedDiscount = null;

        if (discountCode != null && !discountCode.isBlank()) {
            appliedDiscount = discountCodeRepository.findByCodeIgnoreCase(discountCode.trim()).orElse(null);
            if (appliedDiscount != null && "ACTIVE".equalsIgnoreCase(appliedDiscount.getStatus())
                    && !now.isBefore(appliedDiscount.getStartDate())
                    && !now.isAfter(appliedDiscount.getEndDate())
                    && (appliedDiscount.getUsageLimit() == null || appliedDiscount.getUsedCount() < appliedDiscount.getUsageLimit())
                    && subtotal.compareTo(appliedDiscount.getMinOrderAmount()) >= 0) {

                BigDecimal discountAmount;
                if ("PERCENTAGE".equalsIgnoreCase(appliedDiscount.getDiscountType())) {
                    discountAmount = subtotal.multiply(appliedDiscount.getDiscountValue())
                            .divide(new BigDecimal("100"), RoundingMode.HALF_UP);
                    if (appliedDiscount.getMaxDiscountAmount() != null
                            && discountAmount.compareTo(appliedDiscount.getMaxDiscountAmount()) > 0) {
                        discountAmount = appliedDiscount.getMaxDiscountAmount();
                    }
                } else {
                    discountAmount = appliedDiscount.getDiscountValue();
                }

                totalAmount = subtotal.subtract(discountAmount);
                if (totalAmount.compareTo(BigDecimal.ZERO) < 0) {
                    totalAmount = BigDecimal.ZERO;
                }

                appliedDiscount.setUsedCount(appliedDiscount.getUsedCount() + 1);
                discountCodeRepository.save(appliedDiscount);
            } else {
                appliedDiscount = null;
            }
        }

        Order order = new Order();
        order.setUser(user);
        order.setAddress(orderAddress);
        order.setOrderDate(now);
        order.setCreatedAt(now);
        order.setOrderStatus("PENDING");
        order.setPaymentStatus("PENDING_TRANSFER");
        order.setSubtotalAmount(subtotal);
        order.setShippingFee(BigDecimal.ZERO);
        order.setDiscount(appliedDiscount);
        order.setTotalAmount(totalAmount);
        orderRepository.save(order);

        for (CartItem cartItem : cartItems) {
            BigDecimal lineTotal = cartItem.getUnitPrice().multiply(cartItem.getQuantity());
            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setProduct(cartItem.getProduct());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setUnitPrice(cartItem.getUnitPrice());
            orderItem.setAppliedDiscount(BigDecimal.ZERO);
            orderItem.setLineTotal(lineTotal);
            orderItemRepository.save(orderItem);
        }

        Cart cart = cartService.getCartByUserId(user.getUserId());
        cartItemRepository.deleteByCart_CartId(cart.getCartId());

        return "redirect:/checkout/payment-success?orderId=" + order.getOrderId();
    }

    @PostMapping("/address/add")
    @Transactional
    public String addAddress(@RequestParam("receiverName") String receiverName,
                             @RequestParam("phone") String phone,
                             @RequestParam("fullAddress") String fullAddress,
                             @RequestParam(value = "isDefault", required = false) String isDefault,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }

        addressService.addAddress(user.getUserId(), receiverName, phone, fullAddress, "1".equals(isDefault));
        redirectAttributes.addFlashAttribute("successMessage", "Them dia chi giao hang thanh cong.");
        return "redirect:/checkout";
    }

    private String encode(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
    }
}
