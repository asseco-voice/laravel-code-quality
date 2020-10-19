<?php

namespace Voice\CodeQuality\App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;

class GitHooksCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'voice:git-hooks';

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
    public function handle(): void
    {
        $hooksPath = __DIR__ . '/../../../.githooks';

        $repoHooksPath = base_path('.git/hooks');

        File::copyDirectory($hooksPath, $repoHooksPath);

        exec('chmod -R 755 ' . $repoHooksPath);

        $this->info('Git hooks installed.');
    }
}
