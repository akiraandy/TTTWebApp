$(document).ready(() => {
  play();
  // makeCall();
  window.onbeforeunload = function(e) {
    console.log(e.currentTarget.performance.navigation.type)
    if(e.currentTarget.performance.navigation.type == 2)
          {
            console.log("HELLOOO");
               alert("Browser back button is clicked...");
          }
  };
});



// function makeCall() {
//   window.onbeforeunload = function(e) {
//     e.preventDefault();
//     let request = $.ajax({
//       type: "GET",
//       url: "/game",
//       data: {
//         back: 1,
//       }
//     });
//     request.then((response) => {
//       console.log(response);
//     });
//   };
// }

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
      $(`#${move.spot}`).empty();
      $(`#${move.spot}`).append(move.marker);
  });
};

function gameResult(response) {
  if (response.winner) {
    winner(response);
  } else if (response.tie) {
    tie(response);
  };
};

function winner(response) {
  $('#result').append(`<h1>${response.winner}${response.win_locale}</h1>`);
  $('#result').append(`<button type="button" onclick="history.back();">${response.back}</button>`);
};

function tie(response) {
  $('#result').append(`<h1>${response.tie_locale}</h1>`);
  $('#result').append(`<button type="button" onclick="history.back();">${response.back}</button>`);
};
