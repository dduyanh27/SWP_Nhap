package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.ImportReceiptDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.math.BigDecimal;
import java.util.List;

public interface ImportReceiptDetailRepository extends JpaRepository<ImportReceiptDetail, Integer> {

    @Query("SELECT COALESCE(SUM(d.expectedQuantity), 0) FROM ImportReceiptDetail d")
    BigDecimal sumTotalExpectedQuantity();

    @Query("SELECT d.importReceipt.importReceiptId, COALESCE(SUM(d.expectedQuantity), 0) " +
            "FROM ImportReceiptDetail d GROUP BY d.importReceipt.importReceiptId")
    List<Object[]> sumQuantityByReceipt();
}
