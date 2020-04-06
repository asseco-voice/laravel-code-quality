/**
 * Dependencies:
 *
 * brew install node
 * npm install --global gulp-cli
 * npm install gulp gulp-phpunit gulp-notify
 */

const gulp = require('gulp');
const notify = require('gulp-notify');
const phpunit = require('gulp-phpunit');

console.log(getCaller());

gulp.task('tests', function (done) {
    gulp.src('tests/**/*.php')
        .pipe(phpunit('vendor/bin/phpunit tests', {notify: true, clear: true, noInteraction: true, debug: true}))
        .on('error', notify.onError(testNotification('fail')))
        .pipe(notify(testNotification('pass')));
    done();
});

gulp.task('watch', function () {
    gulp.watch(['tests/**/*.php', 'src/**/*.php'], gulp.series(['tests']));
});

gulp.task('default', gulp.series(['tests', 'watch']));

function testNotification(status) {
    return {
        title  : (status === 'pass') ? 'Tests Passed' : 'Tests Failed',
        message: (status === 'pass') ? '\n\nAll tests have passed!\n\n' : '\n\nOne or more tests failed...\n\n',
        icon   : __dirname + '/node_modules/gulp-phpunit/assets/test-' + status + '.png'
    }
}
