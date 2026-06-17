package com.swp391.se2006.g2.vmfruit.dto.response;

import java.util.ArrayList;
import java.util.List;

public class SalesImportProcessResponse {

    private Integer importReceiptId;
    private String importIdDisplay;
    private String supplierName;
    private String createdDateDisplay;
    private int totalExpectedVarieties;
    private List<SalesImportProcessItemResponse> items = new ArrayList<>();

    public Integer getImportReceiptId() {
        return importReceiptId;
    }

    public void setImportReceiptId(Integer importReceiptId) {
        this.importReceiptId = importReceiptId;
    }

    public String getImportIdDisplay() {
        return importIdDisplay;
    }

    public void setImportIdDisplay(String importIdDisplay) {
        this.importIdDisplay = importIdDisplay;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getCreatedDateDisplay() {
        return createdDateDisplay;
    }

    public void setCreatedDateDisplay(String createdDateDisplay) {
        this.createdDateDisplay = createdDateDisplay;
    }

    public int getTotalExpectedVarieties() {
        return totalExpectedVarieties;
    }

    public void setTotalExpectedVarieties(int totalExpectedVarieties) {
        this.totalExpectedVarieties = totalExpectedVarieties;
    }

    public List<SalesImportProcessItemResponse> getItems() {
        return items;
    }

    public void setItems(List<SalesImportProcessItemResponse> items) {
        this.items = items;
    }
}
