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
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/rooms")
public class RoomController {
    private final RoomService roomService = new RoomServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @GetMapping
    public String listRooms(HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        List<Room> rooms = roomService.findAllRooms();
        // Thêm trạng thái thành viên cho mỗi phòng
        for (Room room : rooms) {
            List<User> members = roomService.findMembersByRoomId(room.getRoomId());
            boolean isMember = members.stream().anyMatch(member -> member.getUserId() == current.getUserId());
            room.setMembers(isMember ? List.of(current) : List.of());
        }
        model.addAttribute("rooms", rooms);
        model.addAttribute("suggestions", userService.getFollowSuggestions(current.getUserId()));
        model.addAttribute("currentUser", current);
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
        model.addAttribute("currentUser", current);
        return "create_room";
    }

    @PostMapping("/create")
    public String createRoom(@ModelAttribute("room") Room room, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        room.setUserId(current.getUserId());
        roomService.createRoom(room);
        roomService.addMember(room.getRoomId(), current.getUserId());
        model.addAttribute("message", "Tạo nhóm thành công!");
        return "redirect:/rooms";
    }

    @GetMapping("/{roomId}/edit")
    public String showEditRoomForm(@PathVariable("roomId") int roomId, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        Room room = roomService.findRoomById(roomId);
        if (room == null || room.getUserId() != current.getUserId()) {
            model.addAttribute("error", "Bạn không có quyền chỉnh sửa nhóm này!");
            return "redirect:/rooms";
        }
        model.addAttribute("room", room);
        List<User> suggestions = userService.getFollowSuggestions(current.getUserId());
        model.addAttribute("suggestions", suggestions);
        model.addAttribute("currentUser", current);
        return "edit_room";
    }

    @PostMapping("/{roomId}/edit")
    public String updateRoom(@PathVariable("roomId") int roomId, @ModelAttribute("room") Room room, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        Room existingRoom = roomService.findRoomById(roomId);
        if (existingRoom == null || existingRoom.getUserId() != current.getUserId()) {
            model.addAttribute("error", "Bạn không có quyền chỉnh sửa nhóm này!");
            return "redirect:/rooms";
        }
        room.setRoomId(roomId);
        room.setUserId(current.getUserId());
        roomService.updateRoom(room);
        model.addAttribute("message", "Cập nhật nhóm thành công!");
        return "redirect:/rooms";
    }

    @PostMapping("/{roomId}/delete")
    public String deleteRoom(@PathVariable("roomId") int roomId, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        Room room = roomService.findRoomById(roomId);
        if (room == null || room.getUserId() != current.getUserId()) {
            model.addAttribute("error", "Bạn không có quyền xóa nhóm này!");
            return "redirect:/rooms";
        }
        roomService.deleteRoom(roomId);
        model.addAttribute("message", "Xóa nhóm thành công!");
        return "redirect:/rooms";
    }

    @GetMapping("/{roomId}/members")
    public String listMembers(@PathVariable("roomId") int roomId, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        Room room = roomService.findRoomById(roomId);
        if (room == null) {
            return "redirect:/rooms";
        }
        List<User> members = roomService.findMembersByRoomId(roomId);
        model.addAttribute("room", room);
        model.addAttribute("members", members);
        List<User> suggestions = userService.getFollowSuggestions(current.getUserId());
        model.addAttribute("suggestions", suggestions);
        model.addAttribute("currentUser", current);
        return "room_members";
    }

    @PostMapping("/{roomId}/members/add")
    public String addMember(@PathVariable("roomId") int roomId, @RequestParam("userId") int userId, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        Room room = roomService.findRoomById(roomId);
        if (room == null) {
            model.addAttribute("error", "Nhóm không tồn tại!");
            return "redirect:/rooms";
        }
        try {
            roomService.addMember(roomId, userId);
            model.addAttribute("message", "Tham gia nhóm thành công!");
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tham gia nhóm: " + e.getMessage());
        }
        return "redirect:/rooms";
    }

    @PostMapping("/{roomId}/members/{userId}/remove")
    public String removeMember(@PathVariable("roomId") int roomId, @PathVariable("userId") int userId, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        Room room = roomService.findRoomById(roomId);
        if (room == null || room.getUserId() != current.getUserId()) {
            model.addAttribute("error", "Bạn không có quyền xóa thành viên!");
            return "redirect:/rooms/" + roomId + "/members";
        }
        roomService.removeMember(roomId, userId);
        model.addAttribute("message", "Xóa thành viên thành công!");
        return "redirect:/rooms/" + roomId + "/members";
    }
}