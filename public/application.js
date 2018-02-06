$(document).ready(function() {
  $("td").click(function(e) {
      e.preventDefault();
      $.ajax({
          type: "PUT",
          url: "/game",
          data: {
              space: $(this).attr('id'),
          },
          success: function(result) {
              alert('ok');
          },
          error: function(result) {
              alert('error');
          }
      });
  });
})
