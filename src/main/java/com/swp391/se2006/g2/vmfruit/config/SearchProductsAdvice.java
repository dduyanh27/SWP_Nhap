package com.swp391.se2006.g2.vmfruit.config;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.repository.ProductRepository;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@ControllerAdvice
public class SearchProductsAdvice {

    private final ProductRepository productRepository;
    private final ObjectMapper objectMapper;

    public SearchProductsAdvice(ProductRepository productRepository, ObjectMapper objectMapper) {
        this.productRepository = productRepository;
        this.objectMapper = objectMapper;
    }

    @ModelAttribute("searchProductsJson")
    public String searchProductsJson() {
        List<Map<String, Object>> items = productRepository.findBySellingStatus("ACTIVE").stream()
                .map(this::toSearchItem)
                .toList();
        try {
            return objectMapper.writeValueAsString(items);
        } catch (JsonProcessingException e) {
            return "[]";
        }
    }

    private Map<String, Object> toSearchItem(Product product) {
        Map<String, Object> item = new LinkedHashMap<>();
        item.put("productId", product.getProductId());
        item.put("productName", product.getProductName());
        item.put("basePrice", product.getBasePrice());
        return item;
    }
}
