$(document).ready(() => {
  play();
});

function play() {
  $("td").click(e => {
    e.preventDefault();
    let request = $.ajax({
        type: "PUT",
        url: "/game",
        data: {
            space: $(e.currentTarget).attr('id'),
        },
        dataType: "json"
    });
    request.then((response) => {
      console.log(response);
      putMarkersDown(response);
      if (response.over === true) {
        gameResult(response);
      };
    });
  });
};

function putMarkersDown(response) {
  response.moves.forEach(move => {
    if (move.valid === true) {
      $(`#${move.spot}`).empty();
      $(`#${move.spot}`).append(move.marker);
    };
  });
};

function gameResult(response) {
  if (response.winner) {
    winner(response);
  } else if (response.tie) {
    tie();
  };
};

function winner(response) {
  $('#result').append(`<h1>${response.winner} won!</h1>`);
  $('#result').append('<button type="button" onclick="history.back();">Back</button>');
};

function tie() {
  $('#result').append("<h1>It's a tie!</h1>");
  $('#result').append('<button type="button" onclick="history.back();">Back</button>');
};
