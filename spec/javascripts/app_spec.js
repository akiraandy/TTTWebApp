describe("App", function() {
    beforeEach(() => {
        loadFixtures('myfixture.html');
    });
    describe("#putMarkersDown", function() {
        it ("will fill a cell", function() {
            turn = {moves: [{spot: 5, marker: "X"}]};
            putMarkersDown(turn);
            expect($('[data-id="5"]')).toHaveText("X");
        });

        it ("will fill multiple cells", function() {
            turn = {moves: [{spot: 1, marker: "X"}, {spot: 2, marker: "Y"}]};
            putMarkersDown(turn);
            expect($('[data-id="1"]')).toHaveText("X");
            expect($('[data-id="2"]')).toHaveText("Y");
        });
    });

    describe("#winner", function() {
        it("will show who won", function() {
            response = {winner: "X", win_locale: " won!"};
            winner(response);
            expect($('[data-id="result"]')).toContainText("X won!");
        });

        it("will attach a button to go back", function() {
            response = {};
            winner(response);
            expect($('button')).toExist();
        });
    });

    describe("#tie", function() {
        it("will declare a tie", function() {
            response = {tie_locale: "It's a tie!"};
            tie(response);
            expect($('[data-id="result"]')).toContainText("It's a tie!");
        });

        it("will attach a button to go back", function() {
            response = {};
            winner(response);
            expect($('button')).toExist();
        });
    });

    describe("#gameResult", function() {
        it("will call #winner if there is a winner", function() {
            response = {winner: "X"};
            spyOn(window, 'winner');
            gameResult(response);
            expect(winner).toHaveBeenCalled();
        });

        it("will call #tie if there is a tie", function() {
            response = {tie: true};
            spyOn(window, 'tie');
            gameResult(response);
            expect(tie).toHaveBeenCalled();
        });
    });

    describe("#rewind", function() {
        beforeEach(() => {
            var server;
            server = sinon.fakeServer.create();
            jasmine.Ajax.install();
            rewind();
            request = jasmine.Ajax.requests.mostRecent();
        });

        afterEach(() => {
            jasmine.Ajax.uninstall();
            server.restore();
        });

        it("will make PUT request", function() {
            expect(request.method).toMatch("PUT");
        });

        it("will execute #reloadPage", function() {
            expect(reloadPage).toHaveBeenCalled();
        });

        it("will reload the page", function() {
        });
    });
});
