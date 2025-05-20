$(document).ready(function() {
  // Toggle sidebar when hamburger menu is clicked
  $(".nav-toggle").click(function() {
    $(".sidebar").toggleClass("is-visible");
    $("body").toggleClass("sidebar-visible");
  });
  
  // Close sidebar when clicking outside of it
  $(document).on('click', function(event) {
    if (!$(event.target).closest('.sidebar, .nav-toggle').length) {
      $(".sidebar").removeClass("is-visible");
      $("body").removeClass("sidebar-visible");
    }
  });
});