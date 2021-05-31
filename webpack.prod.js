const merge = require("webpack-merge");
module.exports.AppNamePath = "";
const common = require("./webpack.common.js");

const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');

module.exports = merge(common, {
  mode: "production",
  devtool: "none",
  plugins: [
    new OptimizeCssAssetsPlugin()
  ]
});
