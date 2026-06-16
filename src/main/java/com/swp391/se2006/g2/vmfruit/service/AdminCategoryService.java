package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.entity.Category;

public interface AdminCategoryService {

    /**
     * Tạo category mới với tên cho trước.
     * Nếu đã tồn tại tên đó (không phân biệt hoa thường) thì trả về category cũ.
     */
    Category createCategory(String categoryName);
}
