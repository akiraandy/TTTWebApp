# Tic Tac Toe Web App

* Ruby Version: 2.5.0

This is a web-browser version of the game Tic Tac Toe that provides two game modes: Human Vs. Human and Human Vs. Computer. Upon loading the application, choose the game mode you would like to play and who you would like to start first. First player is always "X" and the player going second will always be "Y". To place a marker on the board, click the cell you wish you place your marker in. Enjoy!

## Setup

To run the application please do the following:

1. Make sure you have [ruby installed](https://www.ruby-lang.org/en/documentation/installation/ "Ruby download page")

2. Make sure you have bundler installed
```
gem install bundler
```

3. Clone the repo to your local machine

```
cd ~
git clone https://github.com/akiraandy/TTTWebApp.git
```

4. In your terminal navigate to the directory containing the repo

```
cd ~/TTTWebApp
```

5. Run bundler
```
bundle install
```

6. Start the server
```
bundle exec shotgun
```

7. Navigate to the localhost address that shotgun gives you in your browser i.e.
```
http://localhost:9393/
```

8. To run the test suite
```
bundle exec rspec
```
