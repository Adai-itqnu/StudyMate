package com.studymate.config;

import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRegistration;
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.DispatcherServlet;

import java.io.File;

public class WebAppInitializer implements WebApplicationInitializer {
    @Override
    public void onStartup(ServletContext sc) throws ServletException {
        // UTF-8 filter
        var f = sc.addFilter("encodingFilter", CharacterEncodingFilter.class);
        f.setInitParameter("encoding", "UTF-8");
        f.setInitParameter("forceEncoding", "true");
        f.addMappingForUrlPatterns(null, false, "/*");

        // Spring context
        var ctx = new AnnotationConfigWebApplicationContext();
        ctx.register(AppConfig.class);
        ctx.setServletContext(sc);

        // DispatcherServlet
        ServletRegistration.Dynamic ds = sc.addServlet("dispatcher",
            new DispatcherServlet(ctx));
        ds.setLoadOnStartup(1);
        ds.addMapping("/");

        // Tạo thư mục upload nếu chưa tồn tại
        String uploadPath = sc.getRealPath("/resources/uploads/");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
            System.out.println("Created upload directory: " + uploadPath);
        }
        
        // multipart config với temp directory được tạo rõ ràng
        String tempDir = System.getProperty("java.io.tmpdir");
        MultipartConfigElement multipartConfig = new MultipartConfigElement(
            tempDir,             // temp dir - sử dụng system temp dir
            5*1024*1024,         // maxFileSize = 5MB
            10*1024*1024,        // maxRequestSize = 10MB
            1024*1024            // fileSizeThreshold = 1MB (threshold để ghi vào disk)
        );
        ds.setMultipartConfig(multipartConfig);
        
        System.out.println("Multipart configuration:");
        System.out.println("- Temp directory: " + tempDir);
        System.out.println("- Max file size: 5MB");
        System.out.println("- Max request size: 10MB");
        System.out.println("- Upload directory: " + uploadPath);
    }
}