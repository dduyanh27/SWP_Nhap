package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.InboundBatch;
import com.swp391.se2006.g2.vmfruit.dto.response.BatchGroupResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface InboundBatchRepository extends JpaRepository<InboundBatch, Integer> {
    @Query("SELECT new com.swp391.se2006.g2.vmfruit.dto.response.BatchGroupResponse(" +
            "b.batchId, b.importReceipt.importReceiptId, b.importReceipt.supplier.supplierName, b.receivedDate, b.batchStatus) " +
            "FROM InboundBatch b ORDER BY b.receivedDate DESC")
    List<BatchGroupResponse> getAllBatchGroups();

    @Query("SELECT b.importReceipt.importReceiptId FROM InboundBatch b")
    List<Integer> findAllImportReceiptIds();

    @Query("SELECT b FROM InboundBatch b WHERE b.batchStatus != 'DELETED'")
    List<InboundBatch> findAllActive();
}