<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Country extends Model
{
    protected $fillable = [
        'name',
        'name_ar',
        'code',
        'phone_code',
        'currency',
        'currency_ar',
        'flag',
        'is_default',
        'is_active',
        'pos',
    ];

    protected $casts = [
        'is_default' => 'boolean',
        'is_active' => 'boolean',
        'pos' => 'integer',
    ];

    public function cities(): HasMany
    {
        return $this->hasMany(City::class)->orderBy('pos')->orderBy('name');
    }

    public function ads(): HasMany
    {
        return $this->hasMany(Ad::class);
    }

    public function getDisplayNameAttribute(): string
    {
        return app()->getLocale() === 'ar' ? $this->name_ar : $this->name;
    }

    public function getDisplayCurrencyAttribute(): string
    {
        return app()->getLocale() === 'ar' ? $this->currency_ar : $this->currency;
    }
}
