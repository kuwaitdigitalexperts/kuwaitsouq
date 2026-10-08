<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Ad;
use App\Models\Category;
use Illuminate\Support\Facades\Artisan;

class KuwaitSouqPagesTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        Artisan::call('migrate');
        Artisan::call('db:seed');
    }

    public function test_home_page_loads_successfully()
    {
        $response = $this->get('/');
        $response->assertStatus(200);
        $response->assertSee('KuwaitSouq');
    }

    public function test_category_page_autos_loads()
    {
        $response = $this->get('/category/autos');
        $response->assertStatus(200);
        // Page contains Arabic or English title
        $response->assertSee('autos');
    }

    public function test_subcategory_page_cars_for_sale_loads()
    {
        $response = $this->get('/category/cars-for-sale');
        $response->assertStatus(200);
        // Checks Arabic name "سيارات للبيع" or slug
        $response->assertSee('cars-for-sale');
    }

    public function test_ad_details_page_loads()
    {
        $ad = Ad::first();
        $this->assertNotNull($ad);

        $response = $this->get('/ads/' . $ad->id);
        $response->assertStatus(200);
        $response->assertSee('3,800');
    }

    public function test_listings_tab_loads()
    {
        $response = $this->get('/listings');
        $response->assertStatus(200);
        $response->assertSee('Listings');
    }

    public function test_account_tab_loads()
    {
        $response = $this->get('/account');
        $response->assertStatus(200);
        $response->assertSee('Account');
    }

    public function test_admin_login_loads()
    {
        $response = $this->get('/admin/login');
        $response->assertStatus(200);
        $response->assertSee('KuwaitSouq Control Center');
    }

    public function test_api_countries_endpoint()
    {
        $response = $this->getJson('/api/v1/countries');
        $response->assertStatus(200);
        $response->assertJsonStructure(['status', 'data']);
    }

    public function test_api_ads_endpoint()
    {
        $response = $this->getJson('/api/v1/ads');
        $response->assertStatus(200);
        $response->assertJsonStructure(['status', 'data']);
    }
}
