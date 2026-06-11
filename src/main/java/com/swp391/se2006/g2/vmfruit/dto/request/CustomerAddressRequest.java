package com.swp391.se2006.g2.vmfruit.dto.request;

public class CustomerAddressRequest {

    private String receiverName;
    private String phone;
    private String fullAddress;
    private Boolean isDefault = false;

    // Constructor
    public CustomerAddressRequest() {}

    public CustomerAddressRequest(String receiverName, String phone, String fullAddress, Boolean isDefault) {
        this.receiverName = receiverName;
        this.phone = phone;
        this.fullAddress = fullAddress;
        this.isDefault = isDefault;
    }

    // Getters & Setters
    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getFullAddress() {
        return fullAddress;
    }

    public void setFullAddress(String fullAddress) {
        this.fullAddress = fullAddress;
    }

    public Boolean getIsDefault() {
        return isDefault;
    }

    public void setIsDefault(Boolean isDefault) {
        this.isDefault = isDefault;
    }
}