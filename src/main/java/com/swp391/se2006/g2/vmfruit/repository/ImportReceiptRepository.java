package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.ImportReceipt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ImportReceiptRepository extends JpaRepository<ImportReceipt, Integer> {

    @Query("SELECT ir FROM ImportReceipt ir JOIN FETCH ir.supplier s " +
            "WHERE (:supplierId IS NULL OR s.supplierId = :supplierId) " +
            "ORDER BY ir.createdDate DESC")
    List<ImportReceipt> findAllWithSupplier(@Param("supplierId") Integer supplierId);
}
