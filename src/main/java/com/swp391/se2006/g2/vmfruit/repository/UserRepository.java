package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {

    boolean existsByEmailIgnoreCase(String email);

    boolean existsByPhone(String phone);

    // Dùng findFirstByPhone thay vì findByPhone để không bị IncorrectResultSizeDataAccessException
    // khi DB có 2 bản ghi trùng SĐT (vd: admin bị duplicate). findFirst = TOP 1 trong SQL.
    Optional<User> findFirstByPhone(String phone);

    Optional<User> findByEmailIgnoreCase(String email);

    Optional<User> findByEmail(String email);

    List<User> findTop5ByOrderByCreatedAtDesc();
}
