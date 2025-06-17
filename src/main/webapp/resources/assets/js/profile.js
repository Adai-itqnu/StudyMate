        function followUser(userId) {
            fetch(`/studymate/profile/follow/${userId}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra khi theo dõi!');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra!');
            });
        }

        function unfollowUser(userId) {
            fetch(`/studymate/profile/unfollow/${userId}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra khi bỏ theo dõi!');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra!');
            });
        }

        function toggleLike(postId) {
            // Logic để like/unlike bài viết
            fetch(`/studymate/profile/like/${postId}`, {
                method: 'POST'
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    location.reload();
                }
            });
        }

        function sharePost(postId) {
            fetch(`/studymate/profile/share/${postId}`, {
                method: 'POST'
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    alert('Đã chia sẻ bài viết!');
                    location.reload();
                }
            });
        }

        function deletePost(postId) {
            if (confirm('Bạn có chắc chắn muốn xóa bài viết này?')) {
                fetch(`/studymate/post/delete/${postId}`, {
                    method: 'POST'
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi xóa bài viết!');
                    }
                });
            }
        }