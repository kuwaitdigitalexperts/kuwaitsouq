<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Category extends Model
{
    protected $fillable = [
        'parent_id',
        'name',
        'name_ar',
        'slug',
        'icon',
        'banner_image',
        'pos',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'pos' => 'integer',
    ];

    public function parent(): BelongsTo
    {
        return $this->belongsTo(Category::class, 'parent_id');
    }

    public function subcategories(): HasMany
    {
        return $this->hasMany(Category::class, 'parent_id')->where('is_active', true)->orderBy('pos');
    }

    public function allSubcategories(): HasMany
    {
        return $this->hasMany(Category::class, 'parent_id')->orderBy('pos');
    }

    public function filters(): HasMany
    {
        return $this->hasMany(CategoryFilter::class)->orderBy('pos');
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
