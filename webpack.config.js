module.exports = {
  entry: {
    "storyboard": "./src/storyboard.ls"
  },
  output: {
    path: __dirname,
    filename: "[name].js"
  },
  module: {
    loaders: [
      { test: /\.ls$/, loader: "livescript-loader" }
    ]
  }
}
