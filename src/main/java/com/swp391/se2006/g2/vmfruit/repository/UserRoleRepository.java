package com.swp391.se2006.g2.vmfruit.repository;

import com.swp391.se2006.g2.vmfruit.entity.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserRoleRepository extends JpaRepository<UserRole, Integer> {

    @Query(value = "SELECT CAST(CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END AS BIT) " +
           "FROM UserRoles ur " +
           "JOIN Users u ON u.user_id = ur.user_id " +
           "JOIN Roles r ON r.role_id = ur.role_id " +
           "WHERE u.user_id = :userId AND r.role_name = :roleName",
           nativeQuery = true)
    boolean existsByUserUserIdAndRoleRoleName(@Param("userId") Integer userId,
                                              @Param("roleName") String roleName);
}
