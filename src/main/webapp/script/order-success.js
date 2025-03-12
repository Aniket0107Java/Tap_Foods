class OrderSuccessAnimation {
    constructor() {
        this.container = null;
        this.confettiColors = ['#22c55e', '#3b82f6', '#f59e0b', '#ec4899', '#8b5cf6'];
        this.init();
    }

    init() {
        // Create container
        this.container = document.createElement('div');
        this.container.className = 'success-animation-container';
        this.container.innerHTML = `
            <div class="success-circle">
                <div class="checkmark-wrapper">
                    <svg class="success-checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
                        <circle class="check-circle" cx="26" cy="26" r="25" fill="none"/>
                        <path class="check" fill="none" stroke="#22c55e" stroke-width="4" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
                    </svg>
                </div>
            </div>
            <div class="success-text">
                <h2 class="success-title">Order Confirmed!</h2>
                <p class="success-message">Your delicious food will be delivered soon</p>
            </div>
            <div class="order-details">
                <div class="detail-row">
                    <span class="detail-label">Order Number</span>
                    <span class="detail-value" id="orderNumber"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Estimated Delivery</span>
                    <span class="detail-value" id="estimatedDelivery"></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Delivery Address</span>
                    <span class="detail-value" id="deliveryAddress"></span>
                </div>
            </div>
            <button class="continue-button" onclick="window.location.href='user_homepage.jsp'">
                Continue Shopping
            </button>
        `;
        document.body.appendChild(this.container);
    }

    createConfetti() {
        for (let i = 0; i < 100; i++) {
            const confetti = document.createElement('div');
            confetti.className = 'confetti';
            
            const color = this.confettiColors[Math.floor(Math.random() * this.confettiColors.length)];
            confetti.style.background = color;
            
            // Random position
            confetti.style.left = Math.random() * 100 + 'vw';
            
            // Random size
            const size = (Math.random() * 10) + 5;
            confetti.style.width = size + 'px';
            confetti.style.height = size + 'px';
            
            // Random rotation
            confetti.style.transform = `rotate(${Math.random() * 360}deg)`;
            
            // Animation
            confetti.style.animation = `confettiRain ${Math.random() * 2 + 3}s linear`;
            
            this.container.appendChild(confetti);
            
            // Remove confetti after animation
            confetti.addEventListener('animationend', () => {
                confetti.remove();
            });
        }
    }

    show(orderDetails) {
        // Set order details
        document.getElementById('orderNumber').textContent = `#${orderDetails.orderNumber}`;
        
        // Calculate and set estimated delivery time (30-45 minutes from now)
        const now = new Date();
        const deliveryTime = new Date(now.getTime() + 45 * 60000);
        const timeString = deliveryTime.toLocaleTimeString([], { 
            hour: '2-digit', 
            minute: '2-digit' 
        });
        document.getElementById('estimatedDelivery').textContent = timeString;
        
        // Set delivery address
        document.getElementById('deliveryAddress').textContent = orderDetails.address;
        
        // Show animation container
        this.container.classList.add('active');
        
        // Start confetti
        this.createConfetti();
        
        // Create confetti interval
        const confettiInterval = setInterval(() => {
            this.createConfetti();
        }, 2000);
        
        // Clear interval after 8 seconds
        setTimeout(() => {
            clearInterval(confettiInterval);
        }, 8000);
    }

    hide() {
        this.container.classList.remove('active');
    }
}