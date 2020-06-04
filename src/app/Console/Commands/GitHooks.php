<?php

namespace Voice\CodeQuality\App\Console\Commands;

use File;
use Illuminate\Console\Command;

class GitHooks extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'asseco-voice:git-hooks';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Installing git pre-commit hooks locally.';

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
     * @return mixed
     */
    public function handle()
    {
        //exec(__DIR__ . '/../../../../setup.sh');
        $hooksPath = __DIR__ . '/../../../.githooks';

        File::copyDirectory($hooksPath, base_path('.git/hooks'));

        //exec('cp -R ${BASEDIR}/.githooks/* ${CALLER_DIR}/.git/hooks');

        $this->info('Git hooks installed.');
    }
}
