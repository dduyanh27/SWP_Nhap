package com.swp391.se2006.g2.vmfruit.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "InboundBatches")
public class InboundBatch {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "batch_id")
    private Integer batchId;

    @OneToOne
    @JoinColumn(name = "import_receipt_id", nullable = false, unique = true)
    private ImportReceipt importReceipt;

    @ManyToOne
    @JoinColumn(name = "received_by_user_id", nullable = false)
    private User receivedByUser;

    @Column(name = "received_date", nullable = false)
    private LocalDateTime receivedDate;

    @Column(name = "batch_status", nullable = false, length = 30)
    private String batchStatus = "ACTIVE";

    @Column(name = "note", length = 255)
    private String note;

    @OneToMany(mappedBy = "batch", cascade = CascadeType.ALL)
    private List<InboundBatchItem> batchItems;

    public Integer getBatchId() {
        return batchId;
    }

    public void setBatchId(Integer batchId) {
        this.batchId = batchId;
    }

    public ImportReceipt getImportReceipt() {
        return importReceipt;
    }

    public void setImportReceipt(ImportReceipt importReceipt) {
        this.importReceipt = importReceipt;
    }

    public User getReceivedByUser() {
        return receivedByUser;
    }

    public void setReceivedByUser(User receivedByUser) {
        this.receivedByUser = receivedByUser;
    }

    public LocalDateTime getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(LocalDateTime receivedDate) {
        this.receivedDate = receivedDate;
    }

    public String getBatchStatus() {
        return batchStatus;
    }

    public void setBatchStatus(String batchStatus) {
        this.batchStatus = batchStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public List<InboundBatchItem> getBatchItems() {
        return batchItems;
    }

    public void setBatchItems(List<InboundBatchItem> batchItems) {
        this.batchItems = batchItems;
    }
}
