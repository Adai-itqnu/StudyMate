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

@Controller
@RequestMapping("/user")
public class UserController {
    
    @Autowired
    private UserDAO userDAO;
    
    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        // Nếu người dùng đã đăng nhập, chuyển hướng đến dashboard
        if (session.getAttribute("user") != null) {
            return "redirect:/dashboard"; // Thay đổi từ /user/dashboard thành /dashboard
        }
        return "login";
    }
    
    @GetMapping("/register")
    public String registerPage(HttpSession session) {
        // Nếu người dùng đã đăng nhập, chuyển hướng đến dashboard
        if (session.getAttribute("user") != null) {
            return "redirect:/dashboard"; // Thay đổi từ /user/dashboard thành /dashboard
        }
        return "register";
    }
    
    @PostMapping("/register")
    public String register(
            @RequestParam("fullName") String fullName,
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            @RequestParam("email") String email,
            HttpSession session,
            RedirectAttributes redirectAttrs) {
        
        // Kiểm tra dữ liệu đầu vào
        if (fullName == null || fullName.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            
            session.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            return "redirect:/user/register";
        }
        
        // Kiểm tra độ dài mật khẩu
        if (password.length() < 6) {
            session.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            return "redirect:/user/register";
        }
        
        User user = new User();
        user.setFullName(fullName);
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setRole("STUDENT"); // Mặc định là học sinh
        
        if (userDAO.registerUser(user)) {
            session.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập");
            return "redirect:/user/login";
        } else {
            session.setAttribute("error", "Tên đăng nhập hoặc email đã tồn tại");
            return "redirect:/user/register";
        }
    }
    
    @PostMapping("/login")
    public String login(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session) {
        
        // Kiểm tra dữ liệu đầu vào
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            session.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            return "redirect:/user/login";
        }
        
        User user = userDAO.login(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            return "redirect:/dashboard"; // Thay đổi từ /user/dashboard thành /dashboard
        } else {
            session.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
            return "redirect:/user/login";
        }
    }
    
    // Xóa method dashboard cũ vì đã có DashboardController xử lý
    
    @GetMapping("/profile/{username}")
    public String viewProfile(@PathVariable("username") String username, 
                            HttpSession session, 
                            Model model) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/user/login";
        }
        
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
    }
    
    @GetMapping("/followers")
    public String followers(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        List<User> followers = userDAO.getFollowers(user.getId());
        model.addAttribute("followers", followers);
        
        return "followers";
    }
    
    @GetMapping("/following")
    public String following(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        List<User> following = userDAO.getFollowing(user.getId());
        model.addAttribute("following", following);
        
        return "following";
    }
    
    @PostMapping("/follow/{id}")
    public String followUser(@PathVariable("id") int followedId, 
                           HttpSession session,
                           RedirectAttributes redirectAttrs) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
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
        return "redirect:/user/profile/" + followedUser.getUsername();
    }
    
    @PostMapping("/unfollow/{id}")
    public String unfollowUser(@PathVariable("id") int followedId, 
                             HttpSession session,
                             RedirectAttributes redirectAttrs) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        if (userDAO.unfollowUser(user.getId(), followedId)) {
            redirectAttrs.addFlashAttribute("message", "Đã hủy theo dõi");
        } else {
            redirectAttrs.addFlashAttribute("error", "Có lỗi xảy ra");
        }
        
        // Chuyển hướng về trang cá nhân của người dùng được theo dõi
        User followedUser = userDAO.getUserById(followedId);
        return "redirect:/user/profile/" + followedUser.getUsername();
    }
    
    @GetMapping("/search")
    public String searchUsers(@RequestParam("keyword") String keyword, 
                            Model model, 
                            HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/user/login";
        }
        
        List<User> users = userDAO.searchUsers(keyword);
        model.addAttribute("users", users);
        model.addAttribute("keyword", keyword);
        
        return "search_results";
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/login";
    }
}