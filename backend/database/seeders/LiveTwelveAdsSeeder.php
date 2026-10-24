<?php

namespace Database\Seeders;

use App\Models\Ad;
use App\Models\AdMedia;
use App\Models\Category;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class LiveTwelveAdsSeeder extends Seeder
{
    /**
     * Run the database seeds for 12 authentic Kuwait products.
     */
    public function run(): void
    {
        $sqlPath = database_path('12_live_products.sql');
        if (file_exists($sqlPath)) {
            DB::unprepared(file_get_contents($sqlPath));
            $this->command->info('Successfully seeded 12 live authentic Kuwait products!');
        } else {
            $this->command->error('12_live_products.sql file not found in database folder.');
        }
    }
}
