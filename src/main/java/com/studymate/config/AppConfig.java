package com.studymate.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebMvc
@ComponentScan("com.studymate")
public class AppConfig implements WebMvcConfigurer {
    
    public AppConfig() {
        System.out.println("=== AppConfig constructor called ===");
    }
    
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        System.out.println("✓ Configuring JSP view resolver: /WEB-INF/views/ + .jsp");
        registry.jsp("/WEB-INF/views/", ".jsp");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        System.out.println("✓ Configuring resource handlers");
        registry.addResourceHandler("/resources/**")
        .addResourceLocations("/resources/");
        registry.addResourceHandler("/css/**")
        .addResourceLocations("/resources/css/");
        registry.addResourceHandler("/js/**")
        .addResourceLocations("/resources/js/");
        registry.addResourceHandler("/assets/**")
        .addResourceLocations("/resources/assets/");
    }

    @Bean
    public MultipartResolver multipartResolver() {
        System.out.println("✓ Creating MultipartResolver bean");
        return new StandardServletMultipartResolver();
    }
}