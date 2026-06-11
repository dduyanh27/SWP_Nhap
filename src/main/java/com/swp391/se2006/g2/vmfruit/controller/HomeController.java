package com.swp391.se2006.g2.vmfruit.controller;

import com.swp391.se2006.g2.vmfruit.entity.Order;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.repository.OrderRepository;
import com.swp391.se2006.g2.vmfruit.repository.ProductRepository;
import com.swp391.se2006.g2.vmfruit.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ReviewService reviewService; // thêm

    @GetMapping({ "/", "/home" })
    public String showHomePage(Model model) {
        List<Product> products = productRepository.findBySellingStatus("ACTIVE");

        model.addAttribute("products", products);
        model.addAttribute("reviews", reviewService.getVisibleReviews()); // thêm
        return "home";
    }
}