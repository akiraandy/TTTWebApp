$(document).ready(() => {
  humanVersusHuman();
  humanVersusComputer();
});

function humanVersusComputer() {
  $("td").click(function(e) {
    e.preventDefault();
    let request = $.ajax({
        type: "PUT",
        url: "/game",
        data: {
            space: $(this).attr('id'),
        },
        dataType: "json"
    });
    request.then((response) => {
        computerTurn(response);
        makeHumanMove(response);
      });
  });
};

function makeHumanMove(response) {
  if (response.valid === true) {
    $('#' + response.spot).empty();
    $('#' + response.spot).append(response.marker);
    endGame(response);
  } else {
    alert("Invalid move");
  };
}

function humanVersusHuman() {
  $("td").click(function(e) {
    e.preventDefault();
    let request = $.ajax({
        type: "PUT",
        url: "/game",
        data: {
            space: $(this).attr('id'),
        },
        dataType: "json"
    });
    request.then((response) => {
        makeHumanMove(response);
        endGame(response);
      });
  });
}

function endGame(response) {
  if (response.winner) {
    console.log("GOT HERE WEEE")
    $('#result').append("<h1>" + response.winner + " won!" + "</h1>");
    $('#result').append('<button type="button" onclick="history.back();">Back</button>');
  } else if (response.tie) {
    $('#result').append("<h1>" + "It's a tie!" + "</h1>");
    $('#result').append('<button type="button" onclick="history.back();">Back</button>');
  }
}

function computerTurn(response) {
  if (response.computer == "Computer") {
    let computer_request = $.ajax({
      type: "PUT",
      url: "/game",
      dataType: "json"
    })
    .then((comp_response) => {
      $('#' + comp_response.spot).empty();
      $('#' + comp_response.spot).append(comp_response.marker);
      endGame(comp_response);
    });
  }
}
