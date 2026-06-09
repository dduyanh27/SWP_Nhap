package com.swp391.se2006.g2.vmfruit.dto.response;

public class BatchStatsResponse {
    private long activeBatchesCount;
    private long expiringBatchesCount;
    private long liquidatedLotsCount;

    public BatchStatsResponse(long activeBatchesCount, long expiringBatchesCount, long liquidatedLotsCount) {
        this.activeBatchesCount = activeBatchesCount;
        this.expiringBatchesCount = expiringBatchesCount;
        this.liquidatedLotsCount = liquidatedLotsCount;
    }
    public long getActiveBatchesCount() { return activeBatchesCount; }
    public long getExpiringBatchesCount() { return expiringBatchesCount; }
    public long getLiquidatedLotsCount() { return liquidatedLotsCount; }
}