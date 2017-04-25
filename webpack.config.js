module.exports = {
  entry: {
    "app/index": "./app/index.ls"
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
