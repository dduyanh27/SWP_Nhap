package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserRoleRepository extends JpaRepository<UserRole, Integer> {

    // Dùng COUNT query trả về long, rồi check > 0 bên Java — tránh mọi vấn đề
    // type-mapping boolean trên SQL Server với Hibernate
    @Query("SELECT COUNT(ur) FROM UserRole ur WHERE ur.user.userId = :userId AND ur.role.roleName = :roleName")
    long countByUserIdAndRoleName(@Param("userId") Integer userId, @Param("roleName") String roleName);

    @Query("SELECT ur.role.roleName FROM UserRole ur WHERE ur.user.userId = :userId")
    List<String> findRoleNamesByUserId(@Param("userId") Integer userId);
}
