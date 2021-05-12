const path = require('path');
const glob = require('glob');

const webpack = require('webpack');
const autoprefixer = require('autoprefixer');
const targetBrowsers = "last 2 version, >0.25% in JP, ie >= 11, not op_mini all";

const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const WebpackAssetsManifest = require('webpack-assets-manifest');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

const entries = {};
const srcDir = "./src/";
const reg=/(.*)(?:\.([^.]+$))/;

glob.sync("**/*.{ts,tsx,js,scss}", {
  ignore: '**/_*.{ts,js,scss}',
  cwd: srcDir
}).map(function (key) {
  key = key.match(reg)[1];
  entries[key] = path.resolve(srcDir, key);
});
entries['images'] = glob.sync('./src/images/**/*.*');

module.exports = {
  entry: entries,
  output: {
    path: path.resolve(__dirname, '../public/bundles'),
    filename: '[name]-[hash].js'
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js", ".json", ".css", ".scss"],
    alias: {
      'vue$': 'vue/dist/vue.esm.js'
    }
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        exclude: /node_modules/,
        use: [
          'ts-loader'
        ]
      },
      {
        test: /\.js?$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'babel-loader',
            options: {
              presets: [
                ['@babel/preset-env',{
                  'targets': targetBrowsers,
                }]
              ]
            }
          },
        ]
      },
      {
        test: /\.scss/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
          },
          'css-loader',
          {
            loader: 'postcss-loader',
            options: {
              postcssOptions: {
                plugins: () => [
                  autoprefixer({
                    grid: true,
                    overrideBrowserslist: [
                      targetBrowsers
                    ]
                  }),
                  require('postcss-flexbugs-fixes')(),
                  require('css-mqpacker')()
                ]
              }
            }
          },
          'resolve-url-loader',
          {
            loader: 'sass-loader',
            options: {
              sassOptions: {
                includePaths: ['./node_modules']
              }
            }
          },
          'import-glob'
        ]
      },
      {
        test: /\.(svg|jpe?g|png|gif|ico)$/,
        exclude: /fonts\//,
        use: [
          {
            loader: 'file-loader',
            options: {
              context: './src/images',
              name: '[path][name]-[hash].[ext]',
              outputPath: 'images',
              publicPath: module.parent.exports.AppNamePath + '/bundles/images/'
            }
          }
        ]
      },
      {
        test: /\.(eot|svg|ttf|woff|woff2)$/,
        exclude: /images\//,
        use: [
          {
            loader: 'file-loader',
            options: {
              context: './src/fonts',
              name: '[path][name]-[hash].[ext]',
              outputPath: 'fonts',
              publicPath: module.parent.exports.AppNamePath + '/bundles/fonts/'
            }
          }
        ]
      },
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: "[name]-[hash].css"
    }),
    new WebpackAssetsManifest({
      output: "manifest.json",
      publicPath: module.parent.exports.AppNamePath + '/bundles/',
    }),
    new CleanWebpackPlugin(),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery"
    })
  ]
};
