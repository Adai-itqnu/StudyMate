package com.studymate.util;

import org.springframework.web.multipart.MultipartFile;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;

public class CloudStorageUtil {
    public static String uploadFile(MultipartFile file) throws Exception {
        String uploadsDir = "/uploads/";
        String original = file.getOriginalFilename();
        String filePath = uploadsDir + System.currentTimeMillis() + "_" + original;
        try (InputStream in = file.getInputStream()) {
            Path target = Paths.get(System.getProperty("catalina.base") + "/webapps" + filePath);
            Files.copy(in, target, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        }
        return filePath;
    }

    /** Xoá file đã upload (trả về true nếu xoá thành công) */
    public static boolean deleteFile(String fileUrl) {
        try {
            Path path = Paths.get(System.getProperty("catalina.base") + "/webapps" + fileUrl);
            return Files.deleteIfExists(path);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}