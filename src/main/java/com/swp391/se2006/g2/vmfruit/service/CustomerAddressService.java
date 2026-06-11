package com.swp391.se2006.g2.vmfruit.service;

import com.swp391.se2006.g2.vmfruit.entity.CustomerAddress;
import java.util.List;

public interface CustomerAddressService {
    List<CustomerAddress> getAddressesByUserId(Integer userId);
    void addAddress(Integer userId, String receiverName, String phone, String fullAddress, boolean isDefault);
    void deleteAddress(Integer addressId);
    void updateAddress(Integer addressId, String receiverName, String phone, String fullAddress);
    CustomerAddress getAddressById(Integer addressId);
    void setDefaultAddress(Integer userId, Integer addressId);
}