package com.swp391.se2006.g2.vmfruit.dto.response;

public class ProductStatsResponse {
    private long lowStockCount;
    private long expiringSoonCount;
    private long hiddenItemsCount;
    private long totalProductsCount;

    public ProductStatsResponse(long lowStockCount, long expiringSoonCount, long hiddenItemsCount, long totalProductsCount) {
        this.lowStockCount = lowStockCount;
        this.expiringSoonCount = expiringSoonCount;
        this.hiddenItemsCount = hiddenItemsCount;
        this.totalProductsCount = totalProductsCount;
    }

    public long getLowStockCount() {
        return lowStockCount;
    }

    public void setLowStockCount(long lowStockCount) {
        this.lowStockCount = lowStockCount;
    }

    public long getExpiringSoonCount() {
        return expiringSoonCount;
    }

    public void setExpiringSoonCount(long expiringSoonCount) {
        this.expiringSoonCount = expiringSoonCount;
    }

    public long getHiddenItemsCount() {
        return hiddenItemsCount;
    }

    public void setHiddenItemsCount(long hiddenItemsCount) {
        this.hiddenItemsCount = hiddenItemsCount;
    }

    public long getTotalProductsCount() {
        return totalProductsCount;
    }

    public void setTotalProductsCount(long totalProductsCount) {
        this.totalProductsCount = totalProductsCount;
    }
}
