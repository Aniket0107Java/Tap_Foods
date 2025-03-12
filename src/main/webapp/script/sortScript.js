document.addEventListener("DOMContentLoaded", () => {
    const sortBySelect = document.querySelector(".sort-by");
    const restaurantGrid = document.querySelector(".restaurant-grid");

    if (!sortBySelect || !restaurantGrid) return;

    // Store the original order of restaurant cards
    const originalOrder = Array.from(restaurantGrid.children);

    sortBySelect.addEventListener("change", () => {
        const selectedValue = sortBySelect.value;
        let restaurantCards = Array.from(originalOrder); // Restore default order before sorting

        if (selectedValue === "0") { 
            // Restore default view
            resetDefaultView();
            return;
        }

        if (selectedValue === "1") { 
            // Sort by Name (Alphabetically)
            restaurantCards.sort((a, b) => a.dataset.name.localeCompare(b.dataset.name));
        } else if (selectedValue === "2") { 
            // Sort by ETA (Numeric)
            restaurantCards.sort((a, b) => {
                let etaA = parseInt(a.querySelector(".eta").textContent.replace(/\D/g, ""));
                let etaB = parseInt(b.querySelector(".eta").textContent.replace(/\D/g, ""));
                return etaA - etaB;
            });
        } else if (selectedValue === "3") { 
            // Filter for Rating 4 and Above
            restaurantCards = restaurantCards.filter(card => {
                let rating = parseFloat(card.querySelector(".restaurant-rating").textContent);
                return rating >= 4.0;
            });
        }

        // Update restaurant list
        restaurantGrid.innerHTML = "";
        restaurantCards.forEach(card => restaurantGrid.appendChild(card));
    });

    function resetDefaultView() {
        // Restore the original restaurant order
        restaurantGrid.innerHTML = "";
        originalOrder.forEach(card => restaurantGrid.appendChild(card));
    }
});
