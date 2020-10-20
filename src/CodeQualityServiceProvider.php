<?php

namespace Voice\CodeQuality;

use Illuminate\Support\ServiceProvider;
use Voice\CodeQuality\App\Console\Commands\GitHooksCommand;
use Voice\CodeQuality\App\Console\Commands\TddCommand;

class CodeQualityServiceProvider extends ServiceProvider
{
    /**
     * Register the application services.
     */
    public function register()
    {
        $this->mergeConfigFrom(__DIR__ . '/Config/asseco-code-quality.php', 'asseco-code-quality');
    }

    /**
     * Bootstrap the application services.
     */
    public function boot()
    {
        $this->publishes([__DIR__ . '/Config/asseco-code-quality.php' => config_path('asseco-code-quality.php')]);

        $this->commands([
            GitHooksCommand::class,
            TddCommand::class,
        ]);
    }
}
