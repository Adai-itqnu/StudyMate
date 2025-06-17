package com.studymate.controller;

import com.studymate.model.Room;
import com.studymate.model.User;
import com.studymate.service.RoomService;
import com.studymate.service.UserService;
import com.studymate.service.impl.RoomServiceImpl;
import com.studymate.service.impl.UserServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/rooms")
public class RoomController {
    private final RoomService roomService = new RoomServiceImpl();
    private final UserService userService = new UserServiceImpl(); // For follow suggestions

    @GetMapping
    public String listRooms(HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }

        List<Room> rooms = roomService.findAllRooms();
        model.addAttribute("rooms", rooms);

        // Add follow suggestions to the model for the sidebar
        List<User> suggestions = userService.getFollowSuggestions(current.getUserId());
        model.addAttribute("suggestions", suggestions);

        return "rooms";
    }

    @GetMapping("/create")
    public String showCreateRoomForm(HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        model.addAttribute("room", new Room());
        List<User> suggestions = userService.getFollowSuggestions(current.getUserId());
        model.addAttribute("suggestions", suggestions);
        return "create_room"; // You'll need to create create_room.jsp
    }

    @PostMapping("/create")
    public String createRoom(@ModelAttribute("room") Room room, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        roomService.createRoom(room);

        List<User> suggestions = userService.getFollowSuggestions(current.getUserId());
        model.addAttribute("suggestions", suggestions);

        return "redirect:/rooms"; // Redirect to the rooms list after creation
    }

    @GetMapping("/{roomId}/chat")
    public String showRoomChat(@PathVariable("roomId") int roomId, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        Room room = roomService.findRoomById(roomId);
        if (room == null) {
            return "redirect:/rooms"; // Or show an error page
        }
        model.addAttribute("room", room);
        List<User> suggestions = userService.getFollowSuggestions(current.getUserId());
        model.addAttribute("suggestions", suggestions);
        return "chat_room"; // You'll need to create chat_room.jsp
    }
} 