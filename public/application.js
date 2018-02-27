$(document).ready(() => {
  let debounced = _.debounce(fireAjax, 1000, {
      'leading': true,
      'trailing': false
  });
   $('[data-cell="cell"]').on('click', (e) => {
       debounced(e);
   });
  browserBackButtonClicked();
});

function fireAjax(e) {
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
}

function browserBackButtonClicked(){

  if (window.history && window.history.pushState) {

    window.history.pushState(null, null, '/game');
    $(window).on('popstate', function() {
        rewind();
    });
  };
};

function goBackToWelcome(){
   document.location.href="/";
};

function rewind(){
    console.log("How about here?");
    let request = $.ajax({
        type: "PUT",
        url: "/rewind",
        dataType: "json"
    });
    request.then(() => {
        console.log("Did we get here?!");
        reloadPage();
        return "HELLO";
    });
};

function reloadPage() {
    location.reload();
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
    $('[data-id=result]').append(`<button type="button" onclick="goBackToWelcome();">${response.back}</button>`);
};

function tie(response) {
    $('[data-id=result]').append(`<h1>${response.tie_locale}</h1>`);
    $('[data-id=result]').append(`<button type="button" onclick="goBackToWelcome();">${response.back}</button>`);
};
