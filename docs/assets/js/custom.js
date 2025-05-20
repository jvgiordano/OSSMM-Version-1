// Toggle sidebar when hamburger is clicked
document.addEventListener('DOMContentLoaded', function() {
  var navToggle = document.querySelector('.nav-toggle');
  
  if (navToggle) {
    navToggle.addEventListener('click', function() {
      document.querySelector('.sidebar').classList.toggle('is-visible');
      document.querySelector('body').classList.toggle('sidebar-visible');
    });
  }
});