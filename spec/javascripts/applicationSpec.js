describe('app', () => {
  let spyEvent;

  beforeEach(() => {
    setFixtures('<td id="1">1</td>');
  });

  it ("should recognize it", () => {
    // let doneFn = jasmine.createSpy("success");
    //
    // jasmine.Ajax.stubRequest('/game').andReturn({
    //   "responseText": "immediate response"
    // });
    //
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = (args) => {
      if (this.readyState == this.DONE) {
        doneFn(this.responseText);
      }
    };

    xhr.open("PUT", "/game");
    xhr.send();

    expect(doneFn).toHaveBeenCalledWith('immediate response');
  });
});
