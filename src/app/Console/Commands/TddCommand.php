<?php

namespace Voice\CodeQuality\App\Console\Commands;

use Illuminate\Console\Command;

class TddCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'asseco-voice:tdd 
                            {--r|repo= : Repository path (defaults to pwd of calling directory)}
                            {--d|dir= : PhpUnit directory to test (defaults to /tests directory)}
                            {--f|files= : No space, comma separated PhpUnit files to test (defaults to /tests directory). Takes precedence before -d flag. Ex. -f=File1,File2,File3}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = "Monitors test folders and auto triggers tests on file change. Don't run in Docker.";

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return void
     */
    public function handle()
    {
        $basedir = __DIR__ . '/../../../scripts/tdd/';

        $options = $this->options();
        $repo = $options['repo'] ? "-r {$options['repo']}" : '';
        $dir = $options['dir'] ? "-d {$options['dir']}" : '';
        $files = $options['files'] ? "-f {$options['files']}" : '';

        while (@ ob_end_flush()) ; // end all output buffers if any

        // this section streams output to terminal
        $proc = popen($basedir . "tdd-watcher.sh $repo $dir $files", 'r');
        while (!feof($proc)) {
            $this->info(fread($proc, 4096));
            @ flush();
        }
    }
}
