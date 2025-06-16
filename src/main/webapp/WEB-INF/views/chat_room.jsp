<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phòng học tập: ${room.roomName}</title>
    <link rel="stylesheet" href="<c:url value='/resources/assets/css/dashboard.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .chat-container {
            display: flex;
            flex-direction: column;
            height: calc(100vh - 200px);
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin: 20px;
            padding: 20px;
        }

        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .message {
            margin-bottom: 15px;
            padding: 10px 15px;
            border-radius: 8px;
            max-width: 70%;
        }

        .message.sent {
            background: #007bff;
            color: white;
            margin-left: auto;
        }

        .message.received {
            background: #e9ecef;
            color: #212529;
        }

        .message-form {
            display: flex;
            gap: 10px;
        }

        .message-input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 16px;
        }

        .send-button {
            padding: 10px 20px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .send-button:hover {
            background: #0056b3;
        }

        .room-info {
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .room-info h3 {
            margin: 0 0 10px 0;
            color: #212529;
        }

        .room-info p {
            margin: 5px 0;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Left Sidebar -->
            <jsp:include page="left_sidebar.jsp" />

            <!-- Center Content -->
            <div class="center-content">
                <div class="chat-container">
                    <div class="room-info">
                        <h3>${room.roomName}</h3>
                        <p>${room.description}</p>
                        <p>Chủ phòng: ${hostUsername}</p>
                    </div>

                    <div class="chat-messages" id="chatMessages">
                        <!-- Messages will be dynamically added here -->
                    </div>

                    <form class="message-form" id="messageForm">
                        <input type="text" class="message-input" id="messageInput" placeholder="Nhập tin nhắn..." required>
                        <button type="submit" class="send-button">Gửi</button>
                    </form>
                </div>
            </div>

            <!-- Right Sidebar -->
            <jsp:include page="right_sidebar.jsp" />
        </div>
    </div>

    <script>
        // WebSocket connection
        const ws = new WebSocket('ws://' + window.location.host + '/studymate/chat/${room.roomId}');
        const chatMessages = document.getElementById('chatMessages');
        const messageForm = document.getElementById('messageForm');
        const messageInput = document.getElementById('messageInput');

        ws.onmessage = function(event) {
            const message = JSON.parse(event.data);
            const messageElement = document.createElement('div');
            messageElement.className = `message ${message.senderId === ${currentUser.userId} ? 'sent' : 'received'}`;
            messageElement.innerHTML = `
                <strong>${message.senderName}</strong>
                <p>${message.content}</p>
                <small>${new Date(message.timestamp).toLocaleString()}</small>
            `;
            chatMessages.appendChild(messageElement);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        };

        messageForm.onsubmit = function(e) {
            e.preventDefault();
            const message = {
                content: messageInput.value,
                roomId: ${room.roomId},
                senderId: ${currentUser.userId},
                senderName: '${currentUser.username}',
                timestamp: new Date().toISOString()
            };
            ws.send(JSON.stringify(message));
            messageInput.value = '';
        };
    </script>
</body>
</html> 