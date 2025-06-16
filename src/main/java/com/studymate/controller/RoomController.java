package com.studymate.controller;

import com.studymate.model.Room;
import com.studymate.model.User;
import com.studymate.service.RoomService;
import com.studymate.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/rooms")
public class RoomController {

    @Autowired
    private RoomService roomService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String roomsPage(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        List<Room> rooms = roomService.getAllRooms();
        model.addAttribute("rooms", rooms);

        List<User> allUsers = userService.getAllUsers();
        List<User> suggestions = allUsers.stream()
                .filter(user -> !user.getUsername().equals(currentUser.getUsername()))
                .collect(Collectors.toList());
        model.addAttribute("suggestions", suggestions);

        model.addAttribute("room", new Room()); // For new room creation form
        return "rooms";
    }

    @PostMapping
    public String addRoom(@ModelAttribute Room room, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        room.setHostId(currentUser.getUserId());
        roomService.addRoom(room);
        return "redirect:/rooms";
    }

    @GetMapping("/edit/{roomId}")
    public String editRoomPage(@PathVariable int roomId, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        Room room = roomService.getRoomById(roomId);
        if (room == null || room.getHostId() != currentUser.getUserId()) {
            return "redirect:/rooms"; // Or show an error
        }
        model.addAttribute("room", room);

        List<User> allUsers = userService.getAllUsers();
        List<User> suggestions = allUsers.stream()
                .filter(user -> !user.getUsername().equals(currentUser.getUsername()))
                .collect(Collectors.toList());
        model.addAttribute("suggestions", suggestions);

        return "rooms"; // Reusing the rooms page for editing
    }

    @PostMapping("/update")
    public String updateRoom(@ModelAttribute Room room, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        Room existingRoom = roomService.getRoomById(room.getRoomId());
        if (existingRoom != null && existingRoom.getHostId() == currentUser.getUserId()) {
            roomService.updateRoom(room);
        }
        return "redirect:/rooms";
    }

    @GetMapping("/delete/{roomId}")
    public String deleteRoom(@PathVariable int roomId, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        Room room = roomService.getRoomById(roomId);
        if (room != null && room.getHostId() == currentUser.getUserId()) {
            roomService.deleteRoom(roomId);
        }
        return "redirect:/rooms";
    }
} 