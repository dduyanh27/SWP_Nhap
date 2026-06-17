package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.ImportReceiptDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.List;

public interface ImportReceiptDetailRepository extends JpaRepository<ImportReceiptDetail, Integer> {


    @Query("SELECT COALESCE(SUM(d.expectedQuantity), 0) FROM ImportReceiptDetail d")
    BigDecimal sumTotalExpectedQuantity();

    @Query("SELECT d.importReceipt.importReceiptId, COALESCE(SUM(d.expectedQuantity), 0) " +
            "FROM ImportReceiptDetail d GROUP BY d.importReceipt.importReceiptId")
    List<Object[]> sumQuantityByReceipt();

    List<ImportReceiptDetail> findByImportReceipt_ImportReceiptId(Integer importReceiptId);
    @Query("SELECT d FROM ImportReceiptDetail d " +
            "JOIN FETCH d.product p " +
            "WHERE d.importReceipt.importReceiptId = :receiptId")
    List<ImportReceiptDetail> findByReceiptIdWithProduct(@Param("receiptId") Integer receiptId);

    @Modifying
    @Query("DELETE FROM ImportReceiptDetail d WHERE d.importReceipt.importReceiptId = :receiptId")
    void deleteByImportReceiptId(@Param("receiptId") Integer receiptId);


    @Query("SELECT COALESCE(SUM(d.expectedQuantity * d.importPrice), 0) " +
            "FROM ImportReceiptDetail d " +
            "WHERE d.importReceipt.importReceiptId = :receiptId")
    BigDecimal sumSubtotalByReceiptId(@Param("receiptId") Integer receiptId);


    boolean existsByImportReceipt_ImportReceiptIdAndProduct_ProductId(
            Integer importReceiptId, Integer productId);
}
