package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.dto.request.ProductRequest;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductRowResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.ProductStatsResponse;
import com.swp391.se2006.g2.vmfruit.entity.Category;
import com.swp391.se2006.g2.vmfruit.entity.Product;
import com.swp391.se2006.g2.vmfruit.entity.ProductCategory;
import com.swp391.se2006.g2.vmfruit.repository.CategoryRepository;
import com.swp391.se2006.g2.vmfruit.repository.InboundBatchItemsRepository;
import com.swp391.se2006.g2.vmfruit.repository.ProductRepository;
import com.swp391.se2006.g2.vmfruit.service.AdminProductService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class AdminProductImpl implements AdminProductService {

    @PersistenceContext
    private EntityManager em;

    private final ProductRepository productRepository;
    private final InboundBatchItemsRepository inboundBatchItemsRepository;
    private final CategoryRepository categoryRepository;

    public AdminProductImpl(ProductRepository productRepository,
                            InboundBatchItemsRepository inboundBatchItemsRepository,
                            CategoryRepository categoryRepository) {
        this.productRepository = productRepository;
        this.inboundBatchItemsRepository = inboundBatchItemsRepository;
        this.categoryRepository = categoryRepository;
    }

    @Override
    public ProductStatsResponse getProductStats() {
        long lowStock = inboundBatchItemsRepository
                .countByItemStatusAndRemainingQuantityLessThanEqual("ACTIVE", new java.math.BigDecimal("5.0"));

        LocalDate today = LocalDate.now();
        LocalDate threeDaysLater = today.plusDays(3);
        long expiringSoon = inboundBatchItemsRepository.countExpiringSoonLotes(today, threeDaysLater);

        long hiddenItems  = productRepository.countBySellingStatus("INACTIVE");
        long totalProducts = productRepository.count();

        return new ProductStatsResponse(lowStock, expiringSoon, hiddenItems, totalProducts);
    }

    @Override
    public List<ProductRowResponse> getAllProductRows() {
        return productRepository.getAllProductRowsForAdmin();
    }

    @Override
    @Transactional
    public Product createProduct(ProductRequest request) {
        Product product = new Product();
        product.setProductName(request.getProductName());
        product.setDescription(request.getDescription());
        product.setImageUrl(request.getImageUrl());
        product.setUnit(request.getUnit());
        product.setBasePrice(request.getBasePrice());
        product.setOrigin(request.getOrigin());
        product.setSellingStatus(
                request.getSellingStatus() != null ? request.getSellingStatus() : "ACTIVE"
        );
        product.setCreatedAt(LocalDateTime.now());

        Product saved = productRepository.save(product);

        // Gán nhiều danh mục
        if (request.getCategoryIds() != null && !request.getCategoryIds().isEmpty()) {
            for (Integer catId : request.getCategoryIds()) {
                categoryRepository.findById(catId).ifPresent(cat -> {
                    ProductCategory pc = new ProductCategory();
                    pc.setProduct(saved);
                    pc.setCategory(cat);
                    saved.getProductCategories().add(pc);
                });
            }
            productRepository.save(saved);
        }

        return saved;
    }

    @Override
    @Transactional(readOnly = true)
    public Product getProductById(Integer productId) {
        Product p = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm id=" + productId));
        // Eagerly initialize lazy collection để tránh LazyInitializationException bên ngoài transaction
        p.getProductCategories().size();
        return p;
    }

    @Override
    @Transactional
    public Product updateProduct(ProductRequest request) {
        Product product = productRepository.findById(request.getProductId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm id=" + request.getProductId()));

        product.setProductName(request.getProductName());
        product.setDescription(request.getDescription());
        product.setImageUrl(request.getImageUrl());
        product.setUnit(request.getUnit());
        product.setBasePrice(request.getBasePrice());
        product.setOrigin(request.getOrigin());
        if (request.getSellingStatus() != null) {
            product.setSellingStatus(request.getSellingStatus());
        }

        // Xoá toàn bộ category cũ, flush ngay để orphanRemoval DELETE chạy trước
        product.getProductCategories().clear();
        em.flush();

        // Thêm các category mới
        if (request.getCategoryIds() != null && !request.getCategoryIds().isEmpty()) {
            for (Integer catId : request.getCategoryIds()) {
                categoryRepository.findById(catId).ifPresent(cat -> {
                    ProductCategory pc = new ProductCategory();
                    pc.setProduct(product);
                    pc.setCategory(cat);
                    product.getProductCategories().add(pc);
                });
            }
        }

        return productRepository.save(product);
    }

    @Override
    @Transactional
    public void toggleProductStatus(Integer productId) {
        Product product = getProductById(productId);
        if ("ACTIVE".equalsIgnoreCase(product.getSellingStatus())) {
            product.setSellingStatus("INACTIVE");
        } else {
            product.setSellingStatus("ACTIVE");
        }
        productRepository.save(product);
    }

    @Override
    @Transactional
    public void deleteProduct(Integer productId) {
        productRepository.deleteById(productId);
    }
}
