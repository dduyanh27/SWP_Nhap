//package com.swp391.se2006.g2.vmfruit.controller;
//
//import com.swp391.se2006.g2.vmfruit.entity.User;
//import jakarta.servlet.http.HttpSession;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PathVariable;
//import org.springframework.web.bind.annotation.RequestMapping;
//
//@Controller
//@RequestMapping("/sales")
//public class SalesController {
//
//    @GetMapping("/dashboard")
//    public String showSalesDashboard() {
//        return "sales-dashboard";
//
//    public String dashboard(Model model, HttpSession session) {
//        User user = (User) session.getAttribute("currentUser");
//        if (user == null) return "redirect:/login";
//        return "sales/dashboard";
//    }
//
//    @GetMapping("/orders")
//    public String orders(Model model, HttpSession session) {
//        User user = (User) session.getAttribute("currentUser");
//        if (user == null) return "redirect:/login";
//        return "sales/orders";
//    }
//
//    @GetMapping("/orders/{id}")
//    public String orderDetail(@PathVariable int id, Model model, HttpSession session) {
//        User user = (User) session.getAttribute("currentUser");
//        if (user == null) return "redirect:/login";
//        return "sales/order-detail";
//    }
//}