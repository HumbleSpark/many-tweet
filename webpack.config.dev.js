module.exports = {
  devtool: 'eval',
  entry: {
    main: './src/js/index.js'
  },
  output: {
    filename: '[name].js',
    path: './build'
  },
  module: {
    loaders: [
      {
        test: /\.elm$/,
        loader: 'elm-webpack'
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          presets: ['es2015', 'react']
        }
      }
    ]
  }
}
