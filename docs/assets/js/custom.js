// Force hamburger menu to be visible and control the sidebar
document.addEventListener('DOMContentLoaded', function() {
  // Make sure sidebar is always shown when hamburger is clicked
  var navToggle = document.querySelector('.nav-toggle');
  
  if (navToggle) {
    navToggle.addEventListener('click', function() {
      document.querySelector('body').classList.toggle('sidebar-visible');
    });
  }
});