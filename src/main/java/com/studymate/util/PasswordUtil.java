package com.studymate.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordUtil {
  private static final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);

  /** Mã hoá mật khẩu */
  public static String hash(String raw) {
    return encoder.encode(raw);
  }

  /** Kiểm tra mật khẩu */
  public static boolean verify(String raw, String hashed) {
    return encoder.matches(raw, hashed);
  }
}
