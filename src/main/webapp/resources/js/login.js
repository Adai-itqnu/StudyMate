// Xử lý form submission với loading animation
document.getElementById('loginForm').addEventListener('submit', function(e) {
    const loginBtn = document.getElementById('loginBtn');
    const loadingSpinner = document.getElementById('loadingSpinner');
    const loginText = document.getElementById('loginText');
    
    // Hiển thị loading
    loadingSpinner.classList.add('show');
    loginText.textContent = 'Đang đăng nhập...';
    loginBtn.disabled = true;
});

// Thêm hiệu ứng focus cho input
document.querySelectorAll('.form-control').forEach(input => {
    input.addEventListener('focus', function() {
        this.parentNode.parentNode.classList.add('focused');
    });
    
    input.addEventListener('blur', function() {
        if (this.value === '') {
            this.parentNode.parentNode.classList.remove('focused');
        }
    });
});

// Auto-hide alerts sau 5 giây
setTimeout(function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        alert.style.animation = 'slideOut 0.3s ease forwards';
        setTimeout(() => alert.remove(), 300);
    });
}, 5000);