package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.response.ProductRowResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductStatsResponse;

import java.util.List;

public interface AdminProductService {
    ProductStatsResponse getProductStats();

    List<ProductRowResponse> getAllProductRows();
}
