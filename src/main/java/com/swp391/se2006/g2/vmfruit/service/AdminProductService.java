package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.request.ProductRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductRowResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductStatsResponse;
import com.swp391.se2006.g2.vmfruit.entity.Product;

import java.util.List;

public interface AdminProductService {
    ProductStatsResponse getProductStats();

    List<ProductRowResponse> getAllProductRows();

    List<ProductRowResponse> getAllProductRows(String sort, String price);

    Product createProduct(ProductRequest request);

    Product getProductById(Integer productId);

    Product updateProduct(ProductRequest request);

    void toggleProductStatus(Integer productId);

    void deleteProduct(Integer productId);
}
