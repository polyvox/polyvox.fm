var gulp = require('gulp'),
    sass = require('gulp-sass'),
    prefix = require('autoprefixer'),
    postcss = require('gulp-postcss'),
    cssnano = require('gulp-cssnano'),
    sourcemaps = require('gulp-sourcemaps'),
    $if = require('gulp-if'),
    babel = require('gulp-babel'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    yargs = require('yargs');

var argv = yargs.alias('p', 'production').argv,
    isProd = argv.p;

gulp.task('build:assets', function () {
  return gulp.src('web/static/assets/**/*')
    .pipe(gulp.dest('priv/static'));
});

gulp.task('build:css', function () {
  var p = prefix({browsers: ['last 2 versions']});

  return gulp.src('web/static/css/*')
    .pipe($if(!isProd, sourcemaps.init()))
      .pipe(sass().on('error', sass.logError))
      .pipe(postcss([p]))
      .pipe($if(isProd, cssnano()))
    .pipe($if(!isProd, sourcemaps.write()))
    .pipe(gulp.dest('priv/static/css'));
});

gulp.task('build:js', function () {
  var p = {
    presets: ['es2015'],
    plugins: ['transform-es2015-modules-umd']
  };
  return gulp.src('web/static/js/*')
    .pipe($if(!isProd, sourcemaps.init()))
      .pipe(babel(p))
      .pipe(concat('app.js'))
      .pipe($if(isProd, uglify()))
    .pipe($if(!isProd, sourcemaps.write()))
    .pipe(gulp.dest('priv/static/js'));
});

gulp.task('watch', ['build'], function () {
  gulp.watch('web/static/css/**/*', ['build:css']);
  gulp.watch('web/static/js/**/*', ['build:js']);
});

gulp.task('build', ['build:css', 'build:js', 'build:assets']);
