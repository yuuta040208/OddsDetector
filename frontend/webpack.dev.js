const { merge } = require("webpack-merge");
module.exports.AppNamePath = "";
const common = require("./webpack.common.js");

module.exports = merge(common, {
  mode: "development",
  devtool: "source-map"
});
