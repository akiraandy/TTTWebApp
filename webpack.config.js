const path = require('path');

const config = {
    entry: ["./public/application.js"],
    output: {
        filename: "bundle.js",
        path: path.resolve(__dirname, 'public')
    },
    module: {
      rules: [
        { test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" }
      ]
    }
}

module.exports = config;
