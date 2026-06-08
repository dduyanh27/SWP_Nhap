package com.swp391.se2006.g2.vmfruit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/sales")
public class SalesController {

    @GetMapping("/dashboard")
    public String showSalesDashboard() {
        return "sales-dashboard";
    }
}
