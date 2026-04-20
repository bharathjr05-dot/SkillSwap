// Main JavaScript functionality for Skill Swap Platform

// Modal functionality
function showModal(modalId) {
    document.getElementById(modalId).classList.add('show');
}

function hideModal(modalId) {
    document.getElementById(modalId).classList.remove('show');
}

// Star rating functionality
function setRating(rating) {
    const stars = document.querySelectorAll('.rating-input .star');
    const ratingInput = document.getElementById('rating');
    
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.remove('empty');
        } else {
            star.classList.add('empty');
        }
    });
    
    if (ratingInput) {
        ratingInput.value = rating;
    }
}

// Search functionality
function searchStudents() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    const studentCards = document.querySelectorAll('.student-card');
    
    studentCards.forEach(card => {
        const name = card.querySelector('.student-name').textContent.toLowerCase();
        const skills = Array.from(card.querySelectorAll('.skill-badge'))
            .map(badge => badge.textContent.toLowerCase())
            .join(' ');
        
        if (name.includes(searchTerm) || skills.includes(searchTerm)) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
}

// Filter by category
function filterByCategory(category) {
    const studentCards = document.querySelectorAll('.student-card');
    
    studentCards.forEach(card => {
        if (category === 'all') {
            card.style.display = 'block';
        } else {
            const skills = Array.from(card.querySelectorAll('.skill-badge'))
                .map(badge => badge.textContent.toLowerCase());
            
            if (skills.some(skill => skill.includes(category.toLowerCase()))) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        }
    });
}

// Filter by department
function filterByDepartment(department) {
    const studentCards = document.querySelectorAll('.student-card');
    
    studentCards.forEach(card => {
        if (department === 'all') {
            card.style.display = 'block';
        } else {
            const deptText = card.textContent.toLowerCase();
            if (deptText.includes(department.toLowerCase())) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        }
    });
}

// Filter by year
function filterByYear(year) {
    const studentCards = document.querySelectorAll('.student-card');
    
    studentCards.forEach(card => {
        if (year === 'all') {
            card.style.display = 'block';
        } else {
            const yearText = card.textContent.toLowerCase();
            if (yearText.includes(year.toLowerCase())) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        }
    });
}

// Form validation
function validateForm(formId) {
    const form = document.getElementById(formId);
    const inputs = form.querySelectorAll('input[required], textarea[required], select[required]');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!input.value.trim()) {
            input.style.borderColor = '#ef4444';
            isValid = false;
        } else {
            input.style.borderColor = '#d1d5db';
        }
    });
    
    return isValid;
}

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    // Close modals when clicking outside
    document.querySelectorAll('.modal').forEach(modal => {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                hideModal(modal.id);
            }
        });
    });
    
    // Initialize star ratings
    document.querySelectorAll('.rating-input .star').forEach((star, index) => {
        star.addEventListener('click', () => setRating(index + 1));
    });
});