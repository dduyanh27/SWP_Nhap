package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.ImportReceipt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ImportReceiptRepository extends JpaRepository<ImportReceipt, Integer> {

    @Query("SELECT ir FROM ImportReceipt ir JOIN FETCH ir.supplier s " +
            "WHERE (:supplierId IS NULL OR s.supplierId = :supplierId) " +
            "ORDER BY ir.createdDate DESC")
    List<ImportReceipt> findAllWithSupplier(@Param("supplierId") Integer supplierId);

    @Query("SELECT ir FROM ImportReceipt ir " +
            "JOIN FETCH ir.supplier s " +
            "JOIN FETCH ir.createdByUser u " +
            "ORDER BY ir.createdDate DESC")
    List<ImportReceipt> findAllWithRelations();
    @Query("SELECT ir FROM ImportReceipt ir " +
            "JOIN FETCH ir.supplier s " +
            "JOIN FETCH ir.createdByUser u " +
            "WHERE ir.importReceiptId = :id")
    Optional<ImportReceipt> findByIdWithRelations(@Param("id") Integer id);

    @Query("SELECT ir FROM ImportReceipt ir " +
            "JOIN FETCH ir.supplier s " +
            "WHERE (:status IS NULL OR ir.status = :status) " +
            "ORDER BY ir.createdDate DESC")
    List<ImportReceipt> findByStatusWithSupplier(@Param("status") String status);
    @Query("SELECT ir FROM ImportReceipt ir " +
            "JOIN FETCH ir.supplier s " +
            "WHERE (:supplierId IS NULL OR s.supplierId = :supplierId) " +
            "AND (:status IS NULL OR ir.status = :status) " +
            "ORDER BY ir.createdDate DESC")
    List<ImportReceipt> findBySupplierAndStatus(
            @Param("supplierId") Integer supplierId,
            @Param("status") String status);

    @Query("SELECT ir FROM ImportReceipt ir " +
            "JOIN FETCH ir.supplier s " +
            "WHERE ir.createdDate BETWEEN :startDate AND :endDate " +
            "ORDER BY ir.createdDate DESC")
    List<ImportReceipt> findByDateRange(
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    long countByStatus(String status);
    @Query("SELECT COALESCE(SUM(ir.totalExpectedQuantity), 0) FROM ImportReceipt ir")
    Integer sumTotalExpectedQuantity();
}