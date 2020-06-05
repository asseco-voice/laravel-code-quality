// Parse command line arguments
const arg = (argList => {
    let arg = {}, a, opt, thisOpt, curOpt;
    for (a = 0; a < argList.length; a++) {
        thisOpt = argList[a].trim();
        opt = thisOpt.replace(/^\-+/, '');

        if (opt === thisOpt) {
            // argument value
            if (curOpt) arg[curOpt] = opt;
            curOpt = null;
        } else {
            // argument name
            curOpt = opt;
            arg[curOpt] = true;
        }
    }
    return arg;
})(process.argv);

const gulp = require('gulp');
const notify = require('gulp-notify');
const phpunit = require('gulp-phpunit');

// Possible flags: -r, -d, -f
const repository_path = arg.r || '';
const directory = arg.d || `${repository_path}/tests`;
const file = arg.f ? `UnitTest ${arg.f}` : null;

const tests_path = `${repository_path}/tests/**/*.php`;
const codebase_path = `${repository_path}/app/**/*.php`;
const phpunit_path = `${repository_path}/vendor/bin/phpunit`;

// Files directly under /tests directory in Laravel are not exactly tests...
const ignore_files = `!${repository_path}/tests/*.*`;

gulp.task('tests', (done) => {
    gulp.src(tests_path)
        .pipe(phpunit(`${phpunit_path} ${file || directory}`, {
            notify       : false,
            clear        : true,
            noInteraction: true,
            debug        : true
        }))
        .on('error', notify.onError(testNotification('fail')))
        .pipe(notify(testNotification('pass')));
    done();
});

gulp.task('watch', () => {
    gulp.watch([tests_path, codebase_path, ignore_files], gulp.series(['tests']));
});

gulp.task('default', gulp.series(['watch']));

function testNotification(status) {
    return {
        title  : (status === 'pass') ? 'Tests passed' : 'Tests failed miserably',
        message: (status === 'pass') ? '\n\nWell congrats!\n\n' : '\n\nYou poor bloke...\n\n',
        icon   : __dirname + '/node_modules/gulp-phpunit/assets/test-' + status + '.png'
    }
}
