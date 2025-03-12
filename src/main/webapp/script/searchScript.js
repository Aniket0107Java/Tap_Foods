const searchInput = document.querySelector("[data-search]");
const restaurantCards = document.querySelectorAll(".restaurant-card");

searchInput.addEventListener("input", (e) => {
	const value = e.target.value.toLowerCase();

	restaurantCards.forEach((card) => {
		const name = card.dataset.name.toLowerCase();
		const cuisine = card.dataset.cuisine.toLowerCase();
		const isVisible = name.includes(value) || cuisine.includes(value);

		card.style.display = isVisible ? "block" : "none";
	});
});
