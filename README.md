# Tic Tac Toe Web App [![Build Status](https://travis-ci.org/akiraandy/TTTWebApp.svg?branch=master)](https://travis-ci.org/akiraandy/TTTWebApp)


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
6. Install karma
```
npm install -g karma-cli

```

6. Run npm
```
npm install
```

7. Start the server
```
npm run server
```

8. Navigate to the localhost address that shotgun gives you in your browser i.e.
```
http://localhost:9393/
```

9. To run the rspec test suite
```
bundle exec rspec
```
10. To run the javascript test suite
```
karma start
```
