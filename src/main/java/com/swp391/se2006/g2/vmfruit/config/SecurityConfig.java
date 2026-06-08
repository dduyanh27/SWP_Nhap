package com.swp391.se2006.g2.vmfruit.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final OAuth2LoginSuccessHandler oauth2LoginSuccessHandler;

    public SecurityConfig(OAuth2LoginSuccessHandler oauth2LoginSuccessHandler) {
        this.oauth2LoginSuccessHandler = oauth2LoginSuccessHandler;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Tắt CSRF để form login thường chạy bình thường
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll() // Thả xích cho toàn bộ các trang JSP chạy tự do
                )
                .logout(logout -> logout.disable())
                .oauth2Login(oauth2 -> oauth2
                        // SỬA DÒNG NÀY: Đổi sang một link giả lập để Spring Security đem cái giao diện xấu xí kia đi chỗ khác chơi
                        .loginPage("/oauth2-login-placeholder")
                        .successHandler(oauth2LoginSuccessHandler)
                );

        return http.build();
    }
}