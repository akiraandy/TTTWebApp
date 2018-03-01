// import * as app from '../../public/application.js';
const app = require("../../public/application.js");
describe("App", function() {
    beforeEach(() => {
        jasmine.getFixtures().fixturesPath = 'base/spec/javascripts/fixtures/';
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

    describe("#winner", function() {
        it("will show who won", function() {
            let response = {winner: "X", win_locale: " won!"};
            app.winner(response);
            expect($('[data-id="result"]')).toContainText("X won!");
        });

        it("will attach a button to go back", function() {
            let response = {};
            app.winner(response);
            expect($('button')).toExist();
        });
    });

    describe("#tie", function() {
        it("will declare a tie", function() {
            let response = {tie_locale: "It's a tie!"};
            app.tie(response);
            expect($('[data-id="result"]')).toContainText("It's a tie!");
        });

        it("will attach a button to go back", function() {
            let response = {};
            app.winner(response);
            expect($('button')).toExist();
        });
    });

    describe("#gameResult", function() {
        it("will call #winner if there is a winner", function() {
            let response = {winner: "Z"};
            spyOn(app, 'winner');
            console.log(app.winner);
            app.gameResult(response);
            expect(app.winner).toHaveBeenCalled();
        });

        xit("will call #tie if there is a tie", function() {
            let response = {tie: true};
            spyOn(app, 'tie');
            app.gameResult(response);
            expect(app.tie).toHaveBeenCalledWith(response);
        });
    });

    describe("#rewind", function() {
        let request;
        let server;
        beforeEach(() => {
            // jasmine.Ajax.install();
            server = sinon.createFakeServer();
            server.respondWith("PUT", "/rewind", [200, { "Content-Type": "application/json"}, '{success: "Success!"}']);
            server.autoRespond = true;
            // request = jasmine.Ajax.requests.mostRecent();
        });

        afterEach(() => {
            server.restore();
            // jasmine.Ajax.uninstall();
        });

       xit("will make PUT request", function() {
            expect(request.method).toMatch("PUT");
        });

        xit("will execute #reloadPage", function() {
            app.rewind();
            expect(app.reloadPage).toHaveBeenCalled();
        });

        xit("will reload the page", function() {
        });
    });
});
