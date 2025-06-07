package com.studymate.controller;

import com.studymate.dao.UserDAO;
import com.studymate.model.User;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.regex.Pattern;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;

@Controller
@RequestMapping("/user")
public class UserController {
    
    @Autowired
    private UserDAO userDAO;
    
    // Email validation pattern
    private static final String EMAIL_PATTERN = 
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
    private static final Pattern pattern = Pattern.compile(EMAIL_PATTERN);
    
    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        // Nếu người dùng đã đăng nhập, chuyển hướng đến dashboard
        if (session.getAttribute("user") != null) {
            return "redirect:/dashboard";
        }
        return "login";
    }
    
    @GetMapping("/register")
    public String registerPage(HttpSession session) {
        // Nếu người dùng đã đăng nhập, chuyển hướng đến dashboard
        if (session.getAttribute("user") != null) {
            return "redirect:/dashboard";
        }
        return "register";
    }
    
    @PostMapping("/register")
    public String register(
            @RequestParam("fullName") String fullName,
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            @RequestParam("email") String email,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "dateOfBirth", required = false) String dateOfBirth,
            HttpSession session,
            RedirectAttributes redirectAttrs) {
        
        try {
            // Kiểm tra dữ liệu đầu vào - trim và kiểm tra null/empty
            if (fullName == null || fullName.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập họ tên");
                return "redirect:/user/register";
            }
            
            if (username == null || username.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập tên đăng nhập");
                return "redirect:/user/register";
            }
            
            if (password == null || password.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập mật khẩu");
                return "redirect:/user/register";
            }
            
            if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng xác nhận mật khẩu");
                return "redirect:/user/register";
            }
            
            if (email == null || email.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập email");
                return "redirect:/user/register";
            }
            
            // Trim dữ liệu
            fullName = fullName.trim();
            username = username.trim();
            password = password.trim();
            confirmPassword = confirmPassword.trim();
            email = email.trim();
            
            // Kiểm tra mật khẩu xác nhận
            if (!password.equals(confirmPassword)) {
                session.setAttribute("error", "Mật khẩu xác nhận không khớp");
                return "redirect:/user/register";
            }
            
            // Validate tên đăng nhập (chỉ chứa chữ cái, số và dấu gạch dưới)
            if (!username.matches("^[a-zA-Z0-9_]{3,20}$")) {
                session.setAttribute("error", "Tên đăng nhập phải từ 3-20 ký tự và chỉ chứa chữ cái, số, dấu gạch dưới");
                return "redirect:/user/register";
            }
            
            // Validate độ dài mật khẩu
            if (password.length() < 6) {
                session.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
                return "redirect:/user/register";
            }
            
            if (password.length() > 50) {
                session.setAttribute("error", "Mật khẩu không được quá 50 ký tự");
                return "redirect:/user/register";
            }
            
            // Validate email format
            if (!isValidEmail(email)) {
                session.setAttribute("error", "Email không hợp lệ");
                return "redirect:/user/register";
            }
            
            // Validate độ dài họ tên
            if (fullName.length() > 100) {
                session.setAttribute("error", "Họ tên không được quá 100 ký tự");
                return "redirect:/user/register";
            }
            
            // Validate số điện thoại nếu có
            if (phone != null && !phone.trim().isEmpty()) {
                phone = phone.trim();
                if (!phone.matches("^[0-9]{10,11}$")) {
                    session.setAttribute("error", "Số điện thoại phải có 10-11 chữ số");
                    return "redirect:/user/register";
                }
            }
            
            // Validate ngày sinh nếu có
            Date birthDate = null;
            if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    birthDate = sdf.parse(dateOfBirth);
                    
                    // Kiểm tra tuổi tối thiểu (13 tuổi)
                    Calendar calendar = Calendar.getInstance();
                    calendar.add(Calendar.YEAR, -13);
                    if (birthDate.after(calendar.getTime())) {
                        session.setAttribute("error", "Bạn phải đủ 13 tuổi để đăng ký");
                        return "redirect:/user/register";
                    }
                    
                    // Kiểm tra ngày sinh không được trong tương lai
                    if (birthDate.after(new Date())) {
                        session.setAttribute("error", "Ngày sinh không hợp lệ");
                        return "redirect:/user/register";
                    }
                } catch (ParseException e) {
                    session.setAttribute("error", "Định dạng ngày sinh không hợp lệ");
                    return "redirect:/user/register";
                }
            }
            
            // Tạo user object
            User user = new User();
            user.setFullName(fullName);
            user.setUsername(username);
            user.setPassword(password); // Password sẽ được hash trong setter
            user.setEmail(email);
            user.setRole("USER"); 
            
            // Set các trường tùy chọn
            if (phone != null && !phone.trim().isEmpty()) {
                user.setPhone(phone);
            }
            if (birthDate != null) {
                user.setDateOfBirth(birthDate);
            }
            
            // Thử đăng ký user
            boolean registrationResult = userDAO.registerUser(user);
            
            if (registrationResult) {
                session.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập");
                // Clear error nếu có
                session.removeAttribute("error");
                return "redirect:/user/login";
            } else {
                session.setAttribute("error", "Tên đăng nhập hoặc email đã tồn tại");
                return "redirect:/user/register";
            }
            
        } catch (Exception e) {
            // Log exception (trong production nên dùng logger)
            System.err.println("Registration error: " + e.getMessage());
            e.printStackTrace();
            
            session.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại");
            return "redirect:/user/register";
        }
    }
    
    /**
     * Validate email format
     */
    private boolean isValidEmail(String email) {
        if (email == null) return false;
        return pattern.matcher(email).matches();
    }
    
    @PostMapping("/login")
    public String login(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session) {
        
        try {
            // Kiểm tra dữ liệu đầu vào
            if (username == null || username.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập tên đăng nhập");
                return "redirect:/user/login";
            }
            
            if (password == null || password.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập mật khẩu");
                return "redirect:/user/login";
            }
            
            // Trim dữ liệu
            username = username.trim();
            password = password.trim();
            
            User user = userDAO.login(username, password);
            if (user != null) {
                session.setAttribute("user", user);
                // Clear error message nếu có
                session.removeAttribute("error");
                return "redirect:/dashboard";
            } else {
                session.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
                return "redirect:/user/login";
            }
            
        } catch (Exception e) {
            // Log exception
            System.err.println("Login error: " + e.getMessage());
            e.printStackTrace();
            
            session.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng nhập. Vui lòng thử lại");
            return "redirect:/user/login";
        }
    }
    
    @GetMapping("/profile/{username}")
    public String viewProfile(@PathVariable("username") String username, 
                            HttpSession session, 
                            Model model) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/user/login";
        }
        
        try {
            // TODO: Implement UserDAO.getUserByUsername
            // User profileUser = userDAO.getUserByUsername(username);
            
            // Tạm thời dùng searchUsers
            List<User> users = userDAO.searchUsers(username);
            if (users.isEmpty()) {
                return "redirect:/dashboard";
            }
            
            User profileUser = users.get(0);
            model.addAttribute("profileUser", profileUser);
            
            // Kiểm tra xem người dùng hiện tại có đang follow người dùng này không
            boolean isFollowing = userDAO.isFollowing(currentUser.getId(), profileUser.getId());
            model.addAttribute("isFollowing", isFollowing);
            
            // Số lượng người theo dõi và đang theo dõi
            List<User> followers = userDAO.getFollowers(profileUser.getId());
            List<User> following = userDAO.getFollowing(profileUser.getId());
            
            model.addAttribute("followers", followers);
            model.addAttribute("following", following);
            
            return "profile";
            
        } catch (Exception e) {
            System.err.println("Profile view error: " + e.getMessage());
            return "redirect:/dashboard";
        }
    }
    
    @GetMapping("/followers")
    public String followers(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        try {
            List<User> followers = userDAO.getFollowers(user.getId());
            model.addAttribute("followers", followers);
            return "followers";
        } catch (Exception e) {
            System.err.println("Followers error: " + e.getMessage());
            return "redirect:/dashboard";
        }
    }
    
    @GetMapping("/following")
    public String following(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        try {
            List<User> following = userDAO.getFollowing(user.getId());
            model.addAttribute("following", following);
            return "following";
        } catch (Exception e) {
            System.err.println("Following error: " + e.getMessage());
            return "redirect:/dashboard";
        }
    }
    
    @PostMapping("/follow/{id}")
    public String followUser(@PathVariable("id") int followedId, 
                           HttpSession session,
                           RedirectAttributes redirectAttrs) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        try {
            if (user.getId() == followedId) {
                redirectAttrs.addFlashAttribute("error", "Bạn không thể theo dõi chính mình");
                return "redirect:/dashboard";
            }
            
            if (userDAO.followUser(user.getId(), followedId)) {
                redirectAttrs.addFlashAttribute("message", "Đã theo dõi thành công");
            } else {
                redirectAttrs.addFlashAttribute("error", "Bạn đã theo dõi người dùng này rồi");
            }
            
            // Chuyển hướng về trang cá nhân của người dùng được theo dõi
            User followedUser = userDAO.getUserById(followedId);
            if (followedUser != null) {
                return "redirect:/user/profile/" + followedUser.getUsername();
            } else {
                return "redirect:/dashboard";
            }
            
        } catch (Exception e) {
            System.err.println("Follow user error: " + e.getMessage());
            redirectAttrs.addFlashAttribute("error", "Có lỗi xảy ra");
            return "redirect:/dashboard";
        }
    }
    
    @PostMapping("/unfollow/{id}")
    public String unfollowUser(@PathVariable("id") int followedId, 
                             HttpSession session,
                             RedirectAttributes redirectAttrs) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        try {
            if (userDAO.unfollowUser(user.getId(), followedId)) {
                redirectAttrs.addFlashAttribute("message", "Đã hủy theo dõi");
            } else {
                redirectAttrs.addFlashAttribute("error", "Có lỗi xảy ra");
            }
            
            // Chuyển hướng về trang cá nhân của người dùng được theo dõi
            User followedUser = userDAO.getUserById(followedId);
            if (followedUser != null) {
                return "redirect:/user/profile/" + followedUser.getUsername();
            } else {
                return "redirect:/dashboard";
            }
            
        } catch (Exception e) {
            System.err.println("Unfollow user error: " + e.getMessage());
            redirectAttrs.addFlashAttribute("error", "Có lỗi xảy ra");
            return "redirect:/dashboard";
        }
    }
    
    @GetMapping("/search")
    public String searchUsers(@RequestParam("keyword") String keyword, 
                            Model model, 
                            HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/user/login";
        }
        
        try {
            if (keyword != null && !keyword.trim().isEmpty()) {
                List<User> users = userDAO.searchUsers(keyword.trim());
                model.addAttribute("users", users);
                model.addAttribute("keyword", keyword.trim());
            } else {
                model.addAttribute("users", List.of());
                model.addAttribute("keyword", "");
            }
            
            return "search_results";
            
        } catch (Exception e) {
            System.err.println("Search users error: " + e.getMessage());
            model.addAttribute("users", List.of());
            model.addAttribute("keyword", keyword);
            return "search_results";
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        try {
            session.invalidate();
        } catch (Exception e) {
            System.err.println("Logout error: " + e.getMessage());
        }
        return "redirect:/index.jsp";
    }
}