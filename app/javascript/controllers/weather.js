document.addEventListener('turbo:load', function() {
  feather.replace();

  function showAddressInput() {
    const wrapper = document.querySelector('.weather-container');
    const addressInput = document.getElementById('addressInput');
    wrapper.style.opacity = '0.5';
    addressInput.style.display = 'block';
    addressInput.style.opacity = '1';
  }

  function hideAddressInput() {
    const wrapper = document.querySelector('.weather-container');
    const addressInput = document.getElementById('addressInput');
    wrapper.style.opacity = '1';
    addressInput.style.opacity = '0';
  }

  // Attach the functions to the global scope if needed
  window.showAddressInput = showAddressInput;
  window.hideAddressInput = hideAddressInput;
});