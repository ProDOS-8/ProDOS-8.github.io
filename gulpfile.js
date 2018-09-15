var gulp        = require('gulp');
var sass        = require('gulp-sass');
var uglify      = require('gulp-uglify');
var prefix      = require('gulp-autoprefixer');
var browserify  = require('browserify');
var browserSync = require('browser-sync');
var rename      = require('gulp-rename');
var cp          = require('child_process');
var jekyll      = process.platform === 'win32' ? 'jekyll.bat' : 'jekyll';
var source      = require('vinyl-source-stream');
var flatten     = require('gulp-flatten');
var es          = require('event-stream');



//
// TASK: sass
//
gulp.task('sass', function () {
  return gulp.src('_scss/main.scss')
    .pipe(sass({
      includePaths: ['scss'],
      outputStyle: 'compressed',
      onError: browserSync.notify
    }))
    .pipe(prefix(['last 15 versions', '> 1%', 'ie 8', 'ie 7'], { cascade: true }))
    .pipe(gulp.dest('_site/css'))
    .pipe(browserSync.reload({stream:true}))
    .pipe(gulp.dest('css'));
});


//
// TASK: js
//
gulp.task('js', function(done) {
  gulp.src('_js/*.js', function(err, files) {
    if(err) done(err);

    var tasks = files.map(function(entry) {
      return browserify({ entries: [entry] })
        .bundle()
        .pipe(source(entry))
        .pipe(rename({extname: '.bundle.js'}))
        .pipe(buffer())
        .pipe(uglify())
        .pipe(flatten())
        .pipe(gulp.dest('_site/js/dist/'))
        .pipe(gulp.dest('js/dist/'));
      });
    es.merge(tasks).on('end', done);
  })
});


//
// TASK: jekyll-build
//
gulp.task('jekyll-build', function (done) {
  return cp.spawn( jekyll , ['build'], {stdio: 'inherit'}).on('close', done);
});



//
// TASK: default
//
gulp.task('default', function(done) {
  console.log("\nPlease pass a task to the gulp command.\nTasks: sass, js, jekyll-build\n\nExample: gulp sass\n");
  done();
});



