package com.studymate.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * Hash password với salt
     */
    public static String hash(String password) throws Exception {
        // Tạo salt ngẫu nhiên
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        
        // Hash password với salt
        MessageDigest md = MessageDigest.getInstance(ALGORITHM);
        md.update(salt);
        byte[] hashedPassword = md.digest(password.getBytes("UTF-8"));
        
        // Kết hợp salt và hash
        byte[] hashWithSalt = new byte[SALT_LENGTH + hashedPassword.length];
        System.arraycopy(salt, 0, hashWithSalt, 0, SALT_LENGTH);
        System.arraycopy(hashedPassword, 0, hashWithSalt, SALT_LENGTH, hashedPassword.length);
        
        // Encode thành Base64
        return Base64.getEncoder().encodeToString(hashWithSalt);
    }
    
    /**
     * Verify password
     */
    public static boolean verify(String password, String hashedPassword) throws Exception {
        try {
            // Decode từ Base64
            byte[] hashWithSalt = Base64.getDecoder().decode(hashedPassword);
            
            // Tách salt và hash
            byte[] salt = new byte[SALT_LENGTH];
            System.arraycopy(hashWithSalt, 0, salt, 0, SALT_LENGTH);
            
            byte[] hash = new byte[hashWithSalt.length - SALT_LENGTH];
            System.arraycopy(hashWithSalt, SALT_LENGTH, hash, 0, hash.length);
            
            // Hash password đầu vào với salt đã lưu
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] testHash = md.digest(password.getBytes("UTF-8"));
            
            // So sánh
            return MessageDigest.isEqual(hash, testHash);
        } catch (Exception e) {
            return false;
        }
    }
}