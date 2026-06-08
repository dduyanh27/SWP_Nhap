package com.swp391.se2006.g2.vmfruit.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "ImportReceiptDetails")
public class ImportReceiptDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "import_detail_id")
    private Integer importDetailId;

    @ManyToOne
    @JoinColumn(name = "import_receipt_id", nullable = false)
    private ImportReceipt importReceipt;

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(name = "expected_quantity", nullable = false, precision = 10, scale = 2)
    private BigDecimal expectedQuantity;

    @Column(name = "import_price", nullable = false, precision = 18, scale = 2)
    private BigDecimal importPrice;

    @Column(name = "expected_expiry_date", nullable = false)
    private LocalDate expectedExpiryDate;

    @Column(name = "note", length = 255)
    private String note;

    public Integer getImportDetailId() {
        return importDetailId;
    }

    public void setImportDetailId(Integer importDetailId) {
        this.importDetailId = importDetailId;
    }

    public ImportReceipt getImportReceipt() {
        return importReceipt;
    }

    public void setImportReceipt(ImportReceipt importReceipt) {
        this.importReceipt = importReceipt;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public BigDecimal getExpectedQuantity() {
        return expectedQuantity;
    }

    public void setExpectedQuantity(BigDecimal expectedQuantity) {
        this.expectedQuantity = expectedQuantity;
    }

    public BigDecimal getImportPrice() {
        return importPrice;
    }

    public void setImportPrice(BigDecimal importPrice) {
        this.importPrice = importPrice;
    }

    public LocalDate getExpectedExpiryDate() {
        return expectedExpiryDate;
    }

    public void setExpectedExpiryDate(LocalDate expectedExpiryDate) {
        this.expectedExpiryDate = expectedExpiryDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
