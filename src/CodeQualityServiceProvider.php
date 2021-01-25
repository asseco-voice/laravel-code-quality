<?php

namespace Asseco\CodeQuality;

use Asseco\CodeQuality\App\Console\Commands\GitHooksCommand;
use Asseco\CodeQuality\App\Console\Commands\TddCommand;
use Illuminate\Support\ServiceProvider;

class CodeQualityServiceProvider extends ServiceProvider
{
    /**
     * Register the application services.
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap the application services.
     */
    public function boot()
    {
        $this->commands([
            GitHooksCommand::class,
            TddCommand::class,
        ]);
    }
}
