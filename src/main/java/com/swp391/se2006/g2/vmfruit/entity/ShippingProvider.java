package com.swp391.se2006.g2.vmfruit.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "ShippingProviders")
public class ShippingProvider {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "shipping_provider_id")
    private Integer shippingProviderId;

    @Column(name = "provider_name", nullable = false, length = 100)
    private String providerName;

    @Column(name = "api_endpoint", length = 255)
    private String apiEndpoint;

    @Column(name = "service_type_id", length = 50)
    private String serviceTypeId;

    @Column(name = "status", nullable = false, length = 20)
    private String status = "ACTIVE";

    public Integer getShippingProviderId() {
        return shippingProviderId;
    }

    public void setShippingProviderId(Integer shippingProviderId) {
        this.shippingProviderId = shippingProviderId;
    }

    public String getProviderName() {
        return providerName;
    }

    public void setProviderName(String providerName) {
        this.providerName = providerName;
    }

    public String getApiEndpoint() {
        return apiEndpoint;
    }

    public void setApiEndpoint(String apiEndpoint) {
        this.apiEndpoint = apiEndpoint;
    }

    public String getServiceTypeId() {
        return serviceTypeId;
    }

    public void setServiceTypeId(String serviceTypeId) {
        this.serviceTypeId = serviceTypeId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
