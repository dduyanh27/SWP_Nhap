package com.swp391.se2006.g2.vmfruit.config;

import com.swp391.se2006.g2.vmfruit.interceptor.AdminInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    private final AdminInterceptor adminInterceptor;

    public WebMvcConfig(AdminInterceptor adminInterceptor) {
        this.adminInterceptor = adminInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // Apply AdminInterceptor to all /admin/** and /sales/** paths
        registry.addInterceptor(adminInterceptor)
                .addPathPatterns("/admin/**", "/sales/**");
    }
}
