<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class City extends Model
{
    protected $fillable = [
        'country_id',
        'name',
        'name_ar',
        'is_active',
        'pos',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'pos' => 'integer',
    ];

    public function country(): BelongsTo
    {
        return $this->belongsTo(Country::class);
    }

    public function neighborhoods(): HasMany
    {
        return $this->hasMany(Neighborhood::class)->orderBy('pos')->orderBy('name');
    }

    public function ads(): HasMany
    {
        return $this->hasMany(Ad::class);
    }

    public function getDisplayNameAttribute(): string
    {
        return app()->getLocale() === 'ar' ? $this->name_ar : $this->name;
    }
}
