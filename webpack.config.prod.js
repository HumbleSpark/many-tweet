const webpack = require('webpack')

module.exports = {
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
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('production')
    }),
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.optimize.AggressiveMergingPlugin(),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin()
  ]
}
