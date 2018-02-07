$(document).ready(function() {
  $("td").click(function(e) {
      e.preventDefault();
      $.ajax({
          type: "PUT",
          url: "/game",
          data: {
              space: $(this).attr('id'),
          },
          dataType: "json",
          success: function(result) {
              $('#' + result.spot).empty();
              $('#' + result.spot).append(result.marker);
          },
          error: function(result) {
              alert('error');
          }
      });
  });
})
