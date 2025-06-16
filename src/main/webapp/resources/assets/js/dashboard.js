// Global variables
        let isLoading = false;
        let currentPage = 1;
        const postsPerPage = 10;

        // DOM Content Loaded
        document.addEventListener('DOMContentLoaded', function() {
            initializeEventListeners();
            loadMorePostsOnScroll();
        });

        // Initialize event listeners
        function initializeEventListeners() {
            // Dropdown toggle
            const userProfile = document.querySelector('.user-profile');
            if (userProfile) {
                userProfile.addEventListener('click', toggleDropdown);
            }

            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                const dropdown = document.getElementById('userDropdown');
                const userDropdown = document.querySelector('.user-dropdown');
                
                if (userDropdown && !userDropdown.contains(event.target)) {
                    dropdown.classList.remove('show');
                }
            });

            // Post form submission
            const postForm = document.querySelector('form[action*="/posts/create"]');
            if (postForm) {
                postForm.addEventListener('submit', handlePostSubmission);
            }

            // Search form enhancement
            const searchForm = document.querySelector('form[action*="/dashboard"]');
            if (searchForm) {
                searchForm.addEventListener('submit', handleSearchSubmission);
            }
        }

        // Toggle user dropdown
        function toggleDropdown() {
            const dropdown = document.getElementById('userDropdown');
            dropdown.classList.toggle('show');
        }

        // Handle post form submission
        function handlePostSubmission(event) {
            event.preventDefault();
            
            const form = event.target;
            const formData = new FormData(form);
            
            // Validation
            const title = formData.get('title').trim();
            const body = formData.get('body').trim();
            
            if (!title || !body) {
                showNotification('Vui lòng điền đầy đủ tiêu đề và nội dung bài viết!', 'error');
                return;
            }

            showLoading(true);
            
            fetch(form.action, {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.ok) {
                    return response.text();
                }
                throw new Error('Network response was not ok');
            })
            .then(data => {
                showNotification('Đăng bài thành công!', 'success');
                form.reset();
                setTimeout(() => {
                    location.reload();
                }, 1000);
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra khi đăng bài!', 'error');
            })
            .finally(() => {
                showLoading(false);
            });
        }

        // Handle search form submission
        function handleSearchSubmission(event) {
            const searchInput = event.target.querySelector('input[name="search"]');
            const searchTerm = searchInput.value.trim();
            
            if (!searchTerm) {
                event.preventDefault();
                showNotification('Vui lòng nhập từ khóa tìm kiếm!', 'warning');
                return;
            }
            
            showLoading(true);
        }

        // Follow user function
        function followUser(userId) {
            if (isLoading) return;
            
            showLoading(true);
            
            fetch(`<c:url value='/profile/follow/'/>` + userId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    showNotification('Đã theo dõi người dùng!', 'success');
                    // Update UI
                    const followBtn = event.target.closest('button');
                    if (followBtn) {
                        followBtn.innerHTML = '<i class="fas fa-check"></i> Đã theo dõi';
                        followBtn.classList.remove('btn-primary');
                        followBtn.classList.add('btn-success');
                        followBtn.disabled = true;
                    }
                } else if (data === 'already_following') {
                    showNotification('Bạn đã theo dõi người dùng này rồi!', 'info');
                } else {
                    showNotification('Có lỗi xảy ra khi theo dõi!', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra!', 'error');
            })
            .finally(() => {
                showLoading(false);
            });
        }

        // Like post function
        function likePost(postId) {
            if (isLoading) return;
            const likeBtn = document.querySelector(`button[onclick="likePost(${postId})"]`);
            const likeCount = document.getElementById(`like-count-${postId}`);
            if (!likeBtn || !likeCount) return;
            showLoading(true);
            fetch(`/posts/like/` + postId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    likeCount.textContent = data.likeCount;
                    if (data.liked) {
                        likeBtn.classList.add('liked');
                        likeBtn.querySelector('i').classList.replace('far', 'fas');
                        showNotification('Đã thích bài viết!', 'success');
                    } else {
                        likeBtn.classList.remove('liked');
                        likeBtn.querySelector('i').classList.replace('fas', 'far');
                        showNotification('Đã bỏ thích bài viết!', 'info');
                    }
                } else {
                    showNotification('Có lỗi xảy ra!', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra!', 'error');
            })
            .finally(() => {
                showLoading(false);
            });
        }

        // Share post function
        function sharePost(postId) {
            if (isLoading) return;
            if (confirm('Bạn có muốn chia sẻ bài viết này không?')) {
                showLoading(true);
                fetch(`/posts/share/` + postId, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        showNotification('Đã chia sẻ bài viết!', 'success');
                        setTimeout(() => { location.reload(); }, 1000);
                    } else {
                        showNotification('Có lỗi xảy ra khi chia sẻ!', 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra!', 'error');
                })
                .finally(() => {
                    showLoading(false);
                });
            }
        }

        // Save post function
        function savePost(postId) {
            if (isLoading) return;
            
            showLoading(true);
            
            fetch(`<c:url value='/posts/save/'/>` + postId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const saveBtn = document.querySelector(`button[onclick="savePost(${postId})"]`);
                    if (data.saved) {
                        saveBtn.innerHTML = '<i class="fas fa-bookmark"></i> Đã lưu';
                        saveBtn.classList.add('saved');
                        showNotification('Đã lưu bài viết!', 'success');
                    } else {
                        saveBtn.innerHTML = '<i class="far fa-bookmark"></i> Lưu';
                        saveBtn.classList.remove('saved');
                        showNotification('Đã bỏ lưu bài viết!', 'info');
                    }
                } else {
                    showNotification('Có lỗi xảy ra!', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra!', 'error');
            })
            .finally(() => {
                showLoading(false);
            });
        }

        // Close search modal
        function closeSearchModal() {
            window.location.href = '<c:url value="/dashboard"/>';
        }

        // Show notification
        function showNotification(message, type = 'info') {
            const toast = document.getElementById('notificationToast');
            const toastMessage = document.getElementById('toastMessage');
            
            // Set message
            toastMessage.textContent = message;
            
            // Set toast style based on type
            toast.className = 'toast';
            switch(type) {
                case 'success':
                    toast.classList.add('bg-success', 'text-white');
                    break;
                case 'error':
                    toast.classList.add('bg-danger', 'text-white');
                    break;
                case 'warning':
                    toast.classList.add('bg-warning', 'text-dark');
                    break;
                default:
                    toast.classList.add('bg-info', 'text-white');
            }
            
            // Show toast
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
        }

        // Show/hide loading spinner
        function showLoading(show) {
            isLoading = show;
            const spinner = document.getElementById('loadingSpinner');
            if (show) {
                spinner.classList.remove('d-none');
            } else {
                spinner.classList.add('d-none');
            }
        }

        // Load more posts on scroll (infinite scroll)
        function loadMorePostsOnScroll() {
            let loading = false;
            
            window.addEventListener('scroll', function() {
                if (loading) return;
                
                const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
                const windowHeight = window.innerHeight;
                const documentHeight = document.documentElement.scrollHeight;
                
                if (scrollTop + windowHeight >= documentHeight - 100) {
                    loading = true;
                    loadMorePosts();
                }
            });
        }

        // Load more posts
        function loadMorePosts() {
            fetch(`<c:url value='/api/posts/load-more'/>?page=${currentPage + 1}&limit=${postsPerPage}`, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success && data.posts.length > 0) {
                    appendPosts(data.posts);
                    currentPage++;
                }
            })
            .catch(error => {
                console.error('Error loading more posts:', error);
            })
            .finally(() => {
                loading = false;
            });
        }

        // Append posts to the main content
        function appendPosts(posts) {
            const mainContent = document.querySelector('.main-content');
            const emptyState = mainContent.querySelector('.empty-state');
            
            if (emptyState) {
                emptyState.remove();
            }
            
            posts.forEach(post => {
                const postElement = createPostElement(post);
                mainContent.appendChild(postElement);
            });
        }

        // Create post element
        function createPostElement(post) {
            const postDiv = document.createElement('div');
            postDiv.className = 'post-card';
            postDiv.innerHTML = `
                <div class="post-header">
                    <img src="${post.authorAvatar || '/assets/images/default-avatar.png'}" alt="Avatar" class="post-avatar">
                    <div class="flex-grow-1">
                        <div class="post-author">${post.authorName || 'User ' + post.userId}</div>
                        <div class="post-time">${formatDate(post.createdAt)}</div>
                    </div>
                    <span class="badge">${post.privacy}</span>
                </div>
                
                <h5 class="post-title">${post.title}</h5>
                <div class="post-content">${post.body}</div>
                
                ${post.attachments && post.attachments.length > 0 ? `
                    <div class="post-attachment">
                        ${post.attachments.map(att => `
                            <img src="${att.fileUrl}" alt="Attachment" class="img-fluid">
                        `).join('')}
                    </div>
                ` : ''}
                
                <div class="post-actions">
                    <button class="action-btn" onclick="likePost(${post.postId})">
                        <i class="fas fa-heart"></i> 
                        <span id="like-count-${post.postId}">${post.likeCount || 0}</span>
                    </button>
                    <button class="action-btn">
                        <i class="fas fa-comment"></i> 
                        <span>${post.commentCount || 0}</span>
                    </button>
                    <button class="action-btn" onclick="sharePost(${post.postId})">
                        <i class="fas fa-share"></i> 
                        <span>${post.shareCount || 0}</span>
                    </button>
                    <button class="action-btn" onclick="savePost(${post.postId})">
                        <i class="fas fa-bookmark"></i> Lưu
                    </button>
                </div>
            `;
            return postDiv;
        }

        // Format date
        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        // Feature card navigation
        function navigateToFeature(feature) {
            const featureUrls = {
                'calendar': '<c:url value="/calendar"/>',
                'notes': '<c:url value="/notes"/>',
                'tasks': '<c:url value="/tasks"/>',
                'library': '<c:url value="/library"/>',
                'groups': '<c:url value="/groups"/>',
                'statistics': '<c:url value="/statistics"/>'
            };
            
            if (featureUrls[feature]) {
                window.location.href = featureUrls[feature];
            }
        }

        // Add click handlers for feature cards
        document.addEventListener('DOMContentLoaded', function() {
            const featureCards = document.querySelectorAll('.feature-card');
            featureCards.forEach((card, index) => {
                const features = ['calendar', 'notes', 'tasks', 'library', 'groups', 'statistics'];
                card.addEventListener('click', () => navigateToFeature(features[index]));
            });
        });

        // Thêm các hàm comment cho bài viết
        function toggleCommentBox(postId) {
            const section = document.getElementById(`comment-section-${postId}`);
            if (section.style.display === 'none') {
                section.style.display = 'block';
            } else {
                section.style.display = 'none';
            }
        }
        function submitComment(event, postId) {
            event.preventDefault();
            const textarea = document.getElementById(`comment-input-${postId}`);
            const content = textarea.value.trim();
            if (!content) return false;
            fetch(`/posts/comment`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `postId=${postId}&content=${encodeURIComponent(content)}`
            })
            .then(res => res.json())
            .then(comment => {
                // Thêm comment mới vào đầu danh sách
                const section = document.getElementById(`comment-section-${postId}`);
                const newComment = document.createElement('div');
                newComment.className = 'd-flex align-items-start mb-2';
                newComment.innerHTML = `
                    <img src="/assets/images/default-avatar.png" class="avatar me-2" style="width:32px;height:32px;">
                    <div>
                        <b>User ${comment.userId}</b>
                        <span class="text-muted small ms-2">Vừa xong</span><br>
                        <span>${comment.content}</span>
                    </div>
                `;
                section.insertBefore(newComment, section.querySelector('form'));
                textarea.value = '';
            });
            return false;
        }