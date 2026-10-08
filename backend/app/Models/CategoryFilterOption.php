<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CategoryFilterOption extends Model
{
    protected $fillable = [
        'category_filter_id',
        'label',
        'label_ar',
        'value',
        'icon',
        'is_quick_card',
        'pos',
    ];

    protected $casts = [
        'is_quick_card' => 'boolean',
        'pos' => 'integer',
    ];

    public function filter(): BelongsTo
    {
        return $this->belongsTo(CategoryFilter::class, 'category_filter_id');
    }

    public function getDisplayLabelAttribute(): string
    {
        return app()->getLocale() === 'ar' ? ($this->label_ar ?: $this->label) : $this->label;
    }
}
