package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.dto.response.BatchGroupResponse;
import com.swp391.se2006.g2.vmfruit.dto.response.BatchStatsResponse;

import java.util.List;

public interface AdminBatchService {
    List<BatchGroupResponse> getBatchManagementData();

    BatchStatsResponse getBatchStats();

    void deleteBatch(Integer id);

    /**
     * Chuyển một BatchItem sang trạng thái CANCELLED.
     * Dữ liệu không bị xóa — giữ nguyên lịch sử nhập kho.
     *
     * @param batchId     ID của lô hàng cha (để kiểm tra tồn tại)
     * @param batchItemId ID của item cần hủy
     * @throws RuntimeException nếu không tìm thấy hoặc item đã bị hủy
     */
    void cancelBatchItem(Integer batchId, Integer batchItemId);

    /**
     * Hủy toàn bộ một lô hàng (batch_status = CANCELLED).
     * Đồng thời chuyển tất cả BatchItem sang CANCELLED.
     * Chỉ được phép nếu lô chưa xuất bán bất kỳ sản phẩm nào
     * (remainingQuantity == acceptedQuantity với mọi item ACTIVE).
     *
     * @param batchId ID lô hàng cần hủy
     * @throws IllegalStateException nếu lô đã có sản phẩm xuất bán
     */
    void cancelBatch(Integer batchId);
}