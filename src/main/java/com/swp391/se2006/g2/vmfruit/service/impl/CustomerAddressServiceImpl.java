package com.swp391.se2006.g2.vmfruit.service.impl;

import com.swp391.se2006.g2.vmfruit.entity.User;
import com.swp391.se2006.g2.vmfruit.entity.CustomerAddress;
import com.swp391.se2006.g2.vmfruit.repository.UserRepository;
import com.swp391.se2006.g2.vmfruit.repository.CustomerAddressRepository;
import com.swp391.se2006.g2.vmfruit.service.CustomerAddressService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CustomerAddressServiceImpl implements CustomerAddressService {

    private final CustomerAddressRepository addressRepository;
    private final UserRepository userRepository;

    public CustomerAddressServiceImpl(CustomerAddressRepository addressRepository, UserRepository userRepository) {
        this.addressRepository = addressRepository;
        this.userRepository = userRepository;
    }

    @Override
    public List<CustomerAddress> getAddressesByUserId(Integer userId) {
        return addressRepository.findByUserUserId(userId);
    }

    @Override
    @Transactional
    public void addAddress(Integer userId, String receiverName, String phone, String fullAddress, boolean isDefault) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));

        // Nếu là địa chỉ mặc định, bỏ mặc định các địa chỉ khác
        if (isDefault) {
            addressRepository.findByUserUserId(userId).forEach(addr -> {
                addr.setIsDefault(false);
                addressRepository.save(addr);
            });
        }

        CustomerAddress address = new CustomerAddress();
        address.setUser(user);
        address.setReceiverName(receiverName);
        address.setPhone(phone);
        address.setFullAddress(fullAddress);
        address.setIsDefault(isDefault);

        addressRepository.save(address);
    }

    @Override
    @Transactional
    public void deleteAddress(Integer addressId) {
        CustomerAddress address = addressRepository.findById(addressId)
                .orElseThrow(() -> new RuntimeException("Địa chỉ không tồn tại"));

        addressRepository.delete(address);
    }

    @Override
    @Transactional
    public void updateAddress(Integer addressId, String receiverName, String phone, String fullAddress) {
        CustomerAddress address = addressRepository.findById(addressId)
                .orElseThrow(() -> new RuntimeException("Địa chỉ không tồn tại"));

        address.setReceiverName(receiverName);
        address.setPhone(phone);
        address.setFullAddress(fullAddress);

        addressRepository.save(address);
    }

    @Override
    public CustomerAddress getAddressById(Integer addressId) {
        return addressRepository.findById(addressId).orElse(null);
    }

    @Override
    @Transactional
    public void setDefaultAddress(Integer userId, Integer addressId) {
        CustomerAddress address = addressRepository.findById(addressId)
                .orElseThrow(() -> new RuntimeException("Địa chỉ không tồn tại"));


        addressRepository.findByUserUserId(userId).forEach(addr -> {
            addr.setIsDefault(false);
            addressRepository.save(addr);
        });

        address.setIsDefault(true);
        addressRepository.save(address);
    }
}