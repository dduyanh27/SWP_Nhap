package com.swp391.se2006.g2.vmfruit;

import com.swp391.se2006.g2.vmfruit.repository.UserRepository;
import com.swp391.se2006.g2.vmfruit.repository.UserRoleRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class VmfruitApplicationTests {

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private UserRoleRepository userRoleRepository;

	@Test
	void contextLoads() {
	}

	@Test
	void testFindRoleNames() {
		userRepository.findByEmailIgnoreCase("admin@vmfruit.com").ifPresent(user -> {
			System.out.println(">>> TESTING - USER ID: " + user.getUserId());
			java.util.List<String> roles = userRoleRepository.findRoleNamesByUserId(user.getUserId());
			System.out.println(">>> TESTING - ROLES FOUND: " + roles);
			boolean isAdminExist = userRoleRepository.existsByUserUserIdAndRoleRoleName(user.getUserId(), "ADMIN");
			System.out.println(">>> TESTING - IS ADMIN EXIST: " + isAdminExist);
		});
	}

}
