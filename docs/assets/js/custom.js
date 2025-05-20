// Wait for document to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
  // Target the hamburger button
  var navToggle = document.querySelector('.nav-toggle');
  
  if (navToggle) {
    // Add click event with multiple fallbacks
    navToggle.addEventListener('click', function(e) {
      e.preventDefault();
      
      // Try getting the sidebar
      var sidebar = document.querySelector('.sidebar');
      
      if (sidebar) {
        // Toggle visibility class
        sidebar.classList.toggle('is-visible');
        document.body.classList.toggle('sidebar-visible');
        
        // Log for debugging
        console.log('Toggled sidebar visibility');
      } else {
        console.error('Sidebar not found');
      }
    });
    
    // Make sure the button is visible by adding a style directly
    navToggle.style.display = 'block';
    console.log('Navigation toggle should be visible now');
  } else {
    console.error('Navigation toggle button not found');
  }
});