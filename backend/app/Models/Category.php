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

    protected $appends = [
        'display_name',
        'icon_url',
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

    public function getIconUrlAttribute(): string
    {
        $slugUnderscore = str_replace('-', '_', $this->slug);
        if (file_exists(public_path("images/categories/{$slugUnderscore}.png"))) {
            return asset("images/categories/{$slugUnderscore}.png");
        }
        if (!empty($this->icon)) {
            $iconFileName = str_ends_with($this->icon, '.png') ? $this->icon : "{$this->icon}.png";
            if (file_exists(public_path("images/categories/{$iconFileName}"))) {
                return asset("images/categories/{$iconFileName}");
            }
        }
        return asset("images/categories/all_categories.png");
    }
}
