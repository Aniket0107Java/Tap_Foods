
       document.addEventListener('DOMContentLoaded', function () {
           const cartCount = document.querySelector('.cart-count'); // Total items count in the cart
           const cartTotal = document.querySelector('.cart-total span:last-child'); // Total price display
           let totalItems = 0; // Total number of items
           let totalPrice = 0; // Total price of all items in the cart

           document.querySelectorAll('.menu-item').forEach(item => {
               const addButton = item.querySelector('.add-to-cart'); // Add to cart button
               const quantityControls = item.querySelector('.quantity-controls'); // Quantity control section
               const quantityDisplay = item.querySelector('.quantity'); // Current quantity display
               const plusBtn = item.querySelector('.plus'); // Plus button
               const minusBtn = item.querySelector('.minus'); // Minus button

               // Extract item price by removing the currency symbol (₹, $)
               const itemPriceText = item.querySelector('.price').textContent.trim();
               const itemPrice = parseFloat(itemPriceText.replace(/[^0-9.]/g, '')); // Remove non-numeric characters

               let quantity = 0; // Current quantity for the menu item

               // Skip disabled items
               if (addButton.disabled) return;

               // Add item to cart
               addButton.addEventListener('click', () => {
                   quantity = 1; // Set quantity to 1
                   totalItems++; // Increment total items count
                   totalPrice += itemPrice; // Add item price to total price
                   updateCartDisplay();
                   quantityDisplay.textContent = quantity; // Update quantity display
                   addButton.classList.add('hidden'); // Hide add button
                   quantityControls.classList.remove('hidden'); // Show quantity controls
               });

               // Increase item quantity
               plusBtn.addEventListener('click', () => {
                   quantity++; // Increment quantity
                   totalItems++; // Increment total items count
                   totalPrice += itemPrice; // Add item price to total price
                   updateCartDisplay();
                   quantityDisplay.textContent = quantity; // Update quantity display
               });

               // Decrease item quantity
               minusBtn.addEventListener('click', () => {
                   if (quantity >= 0) {
                       quantity--; // Decrement quantity
                       totalItems--; // Decrement total items count
                       totalPrice -= itemPrice; // Subtract item price from total price
                       updateCartDisplay();
                       quantityDisplay.textContent = quantity; // Update quantity display

                       // If quantity is 0, reset controls
                       if (quantity === 0) {
                           addButton.classList.remove('hidden'); // Show add button
                           quantityControls.classList.add('hidden'); // Hide quantity controls
                       }
                   }
               });
           });

           // Update cart display for total items and total price
           function updateCartDisplay() {
               cartCount.textContent = totalItems; // Update total item count in cart
               cartTotal.textContent = `₹${totalPrice.toFixed(2)}`; // Update total price in cart
           }
       });

       const cartItems = document.querySelector('.cart-items');
       const cartTotal = document.querySelector('.cart-total span:last-child');
       let total = 0;

       function updateCart(item, price, quantity) {
           const cartItem = document.createElement('div');
           cartItem.className = 'cart-item';
           cartItem.innerHTML = `
               <img src="${item.querySelector('img').src}" alt="${item.querySelector('h2').textContent}">
               <div class="cart-item-details">
                   <div class="cart-item-name">${item.querySelector('h2').textContent}</div>
                   <div class="cart-item-price">$${price}</div>
               </div>
               <div class="item-quantity">${quantity}</div>
           `;
           cartItems.appendChild(cartItem);
           
           total += price * quantity;
           cartTotal.textContent = `$${total.toFixed(2)}`;
           
       }

       // Add event listeners for add to cart buttons
       document.querySelectorAll('.add-to-cart').forEach(button => {
           button.addEventListener('click', () => {
               const menuItem = button.closest('.menu-item');
               const price = parseFloat(menuItem.querySelector('.price').textContent.replace('$', ''));
               updateCart(menuItem, price, 1);
           });
       });