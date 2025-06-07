 // Set max date for date of birth (18 years ago)
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const maxDate = new Date(today.getFullYear() - 13, today.getMonth(), today.getDate());
            document.getElementById('dateOfBirth').max = maxDate.toISOString().split('T')[0];
        });

        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const toggle = document.getElementById('toggle' + fieldId.charAt(0).toUpperCase() + fieldId.slice(1));
            
            if (field.type === 'password') {
                field.type = 'text';
                toggle.classList.remove('fa-eye');
                toggle.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                toggle.classList.remove('fa-eye-slash');
                toggle.classList.add('fa-eye');
            }
        }

        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthDiv = document.getElementById('passwordStrength');
            
            if (password.length === 0) {
                strengthDiv.innerHTML = '';
                return;
            }
            
            let strength = 0;
            let feedback = [];
            
            // Length check
            if (password.length >= 8) strength += 1;
            else feedback.push('ít nhất 8 ký tự');
            
            // Uppercase check
            if (/[A-Z]/.test(password)) strength += 1;
            else feedback.push('chữ hoa');
            
            // Lowercase check
            if (/[a-z]/.test(password)) strength += 1;
            else feedback.push('chữ thường');
            
            // Number check
            if (/[0-9]/.test(password)) strength += 1;
            else feedback.push('số');
            
            // Special character check
            if (/[^A-Za-z0-9]/.test(password)) strength += 1;
            else feedback.push('ký tự đặc biệt');
            
            let strengthText = '';
            let strengthClass = '';
            
            if (strength <= 2) {
                strengthText = 'Yếu';
                strengthClass = 'strength-weak';
            } else if (strength <= 3) {
                strengthText = 'Trung bình';
                strengthClass = 'strength-medium';
            } else {
                strengthText = 'Mạnh';
                strengthClass = 'strength-strong';
            }
            
            if (feedback.length > 0) {
                strengthDiv.innerHTML = `<span class="${strengthClass}">Độ mạnh: ${strengthText}</span><br><small>Cần thêm: ${feedback.join(', ')}</small>`;
            } else {
                strengthDiv.innerHTML = `<span class="${strengthClass}">Độ mạnh: ${strengthText}</span>`;
            }
        }

        function checkPasswordMatch() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchDiv = document.getElementById('passwordMatch');
            
            if (confirmPassword.length === 0) {
                matchDiv.innerHTML = '';
                return;
            }
            
            if (password === confirmPassword) {
                matchDiv.innerHTML = '<span class="match-success"><i class="fas fa-check"></i> Mật khẩu khớp</span>';
            } else {
                matchDiv.innerHTML = '<span class="match-error"><i class="fas fa-times"></i> Mật khẩu không khớp</span>';
            }
        }

        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }
            
            return true;
        }