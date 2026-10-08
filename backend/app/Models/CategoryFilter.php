<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class CategoryFilter extends Model
{
    protected $fillable = [
        'category_id',
        'name',
        'name_ar',
        'filter_key',
        'type',
        'is_pinned',
        'pos',
    ];

    protected $casts = [
        'is_pinned' => 'boolean',
        'pos' => 'integer',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function options(): HasMany
    {
        return $this->hasMany(CategoryFilterOption::class)->orderBy('pos');
    }

    public function quickCards(): HasMany
    {
        return $this->hasMany(CategoryFilterOption::class)->where('is_quick_card', true)->orderBy('pos');
    }

    public function getDisplayNameAttribute(): string
    {
        return app()->getLocale() === 'ar' ? ($this->name_ar ?: $this->name) : $this->name;
    }
}
