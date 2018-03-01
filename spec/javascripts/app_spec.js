const app = require("../../public/application.js");
describe("App", function() {
    beforeEach(() => {
        jasmine.getFixtures().fixturesPath = 'base/spec/javascripts/fixtures/';
        jasmine.getStyleFixtures().fixturesPath = 'base/spec/css/fixtures/';
        loadStyleFixtures('mycssfixture.css');
        loadFixtures('myfixture.html');
    });
    describe("#putMarkersDown", function() {
        it ("will fill a cell", function() {
            let turn = {moves: [{spot: 5, marker: "X"}]};
            app.putMarkersDown(turn);
            expect($('[data-id="5"]')).toHaveText("X");
        });

        it ("will fill multiple cells", function() {
            let turn = {moves: [{spot: 1, marker: "X"}, {spot: 2, marker: "Y"}]};
            app.putMarkersDown(turn);
            expect($('[data-id="1"]')).toHaveText("X");
            expect($('[data-id="2"]')).toHaveText("Y");
        });
    });

    describe("#game_result", function() {
        it("will show who won", function() {
            let response = {winner: "X", win_locale: " won!"};
            app.gameResult(response);
            expect($('[data-id="result"]')).toContainText("X won!");
        });

        it("will declare a tie", function() {
            let response = {tie: true, tie_locale: "It's a tie!"};
            app.gameResult(response);
            expect($('[data-id="result"]')).toContainText("It's a tie!");
        });

        it("will attach a button to go back", function() {
            let response = {winner: "X"};
            app.gameResult(response);
            expect($('button')).toExist();
        });
    });

    describe("#turnOnSpinner", function() {
        it("will display a spinner", function() {
            app.turnOnSpinner();
            expect($('[data-id="result"]')).toHaveClass("spinner");
        });
    });

    describe("#turnOffSpinner", function() {

        it("will remove loader", function () {
            $('[data-id="result"]').addClass('spinner');
            app.turnOffSpinner();
            expect($('[data-id=result]')).not.toHaveClass("spinner");
        });
    });
});
