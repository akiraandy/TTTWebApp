// import _ from "lodash";
import $ from "jquery";
$(document).ready(() => {
  // clickCell();
  browserBackButtonClicked();
});

//   let debounced = _.debounce(fireAjax, 5000, {
//       'leading': true,
//       'trailing': false
//   });
//    $('[data-cell="cell"]').on('click', (e) => {
//        debounced(e);
//    });
// }

export function fireAjax(e) {
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

export function browserBackButtonClicked(){

  if (window.history && window.history.pushState) {

    window.history.pushState(null, null, '/game');
    $(window).on('popstate', function() {
        rewind();
    });
  };
};

export function goBackToWelcome(){
   document.location.href="/";
};

export function rewind(){
    let request = $.ajax({
        type: "PUT",
        url: "/rewind",
        dataType: "json"
    });
    request.then(() => {
        reloadPage();
    });
};

export function reloadPage() {
    location.reload();
};

export function putMarkersDown(response) {
    response.moves.forEach(move => {
      $(`[data-id=${move.spot}]`).empty();
      $(`[data-id=${move.spot}]`).append(move.marker);
    });
};

export function gameResult(response) {
    if (response.winner) {
        console.log(winner);
        winner(response);
    } else if (response.tie) {
        tie(response);
    };
};

export function winner(response) {
    $('[data-id=result]').append(`<h1>${response.winner}${response.win_locale}</h1>`);
    $('[data-id=result]').append(`<button type="button" data-id="goBack">${response.back}</button>`);
    $('[data-id="goBack"]').click(() => {
       goBackToWelcome();
    });
};

export function tie(response) {
    $('[data-id=result]').append(`<h1>${response.tie_locale}</h1>`);
    $('[data-id=result]').append(`<button type="button" data-id="goBack">${response.back}</button>`);
    $('[data-id="goBack"]').click(() => {
       goBackToWelcome();
    });
};
