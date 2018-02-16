$(document).ready(() => {
  play();
  browserBackButtonClicked();
  goBackToWelcome();
});

function browserBackButtonClicked(){

  if (window.history && window.history.pushState) {

    window.history.pushState(null, null, '/game');
    $(window).on('popstate', function() {
        rewind();
    });
  };
};

function goBackToWelcome(){
    $('[data-id=gobacktowelcome]').click(e => {
       e.preventDefault();
       document.location.href="/";
    });
}

function rewind(){
let request = $.ajax({
        type: "PUT",
        url: "/rewind",
        dataType: "json"
    });
    request.then(() => {
        location.reload();
    });
};

function play() {
    $('[data-cell="cell"]').click(e => {
    e.preventDefault();
    let request = $.ajax({
        type: "PUT",
        url: "/game",
        data: {
            space: $(e.currentTarget).data('id'),
        },
    dataType: "json"
    });
    request.then((response) => {
      putMarkersDown(response);
      if (response.over === true) {
        gameResult(response);
      };
    });
    });
};

function putMarkersDown(response) {
    response.moves.forEach(move => {
      $(`[data-id=${move.spot}]`).empty();
      $(`[data-id=${move.spot}]`).append(move.marker);
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
    $('[data-id=result]').append(`<h1>${response.winner}${response.win_locale}</h1>`);
    $('[data-id=result]').append(`<button type="button" onclick="history.back();">${response.back}</button>`);
};

function tie(response) {
    $('[data-id=result]').append(`<h1>${response.tie_locale}</h1>`);
    $('[data-id=result]').append(`<button type="button" onclick="history.back();">${response.back}</button>`);
};
