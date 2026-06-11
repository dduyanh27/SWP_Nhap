package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.request.ProductRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductRowResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductStatsResponse;
import com.swp391.se2006.g2.vmfruit.entity.Product;

import java.util.List;

public interface AdminProductService {
    ProductStatsResponse getProductStats();

    List<ProductRowResponse> getAllProductRows();

    /** Tạo sản phẩm mới, trả về entity đã lưu */
    Product createProduct(ProductRequest request);

    /** Lấy entity theo id để điền vào form chỉnh sửa */
    Product getProductById(Integer productId);

    /** Cập nhật thông tin sản phẩm */
    Product updateProduct(ProductRequest request);

    /** Ẩn/Hiện sản phẩm (toggle ACTIVE ↔ INACTIVE) */
    void toggleProductStatus(Integer productId);

    /** Xoá vĩnh viễn sản phẩm */
    void deleteProduct(Integer productId);
}
