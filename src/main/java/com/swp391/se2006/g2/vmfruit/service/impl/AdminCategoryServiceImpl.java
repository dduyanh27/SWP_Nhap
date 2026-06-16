package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.entity.Category;
import com.swp391.se2006.g2.vmfruit.repository.CategoryRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminCategoryService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class AdminCategoryServiceImpl implements AdminCategoryService {

    private final CategoryRepository categoryRepository;

    public AdminCategoryServiceImpl(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Override
    @Transactional
    public Category createCategory(String categoryName) {
        // Kiểm tra trùng tên (không phân biệt hoa thường)
        Optional<Category> existing = categoryRepository.findByCategoryName(categoryName.trim());
        if (existing.isPresent()) {
            return existing.get();   // trả về category cũ, không tạo trùng
        }

        Category category = new Category();
        category.setCategoryName(categoryName.trim());
        category.setStatus("ACTIVE");
        return categoryRepository.save(category);
    }
}
