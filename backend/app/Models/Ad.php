<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Carbon\Carbon;

class Ad extends Model
{
    protected $fillable = [
        'user_id',
        'category_id',
        'sub_category_id',
        'country_id',
        'city_id',
        'neighborhood_id',
        'neighborhood_name',
        'title',
        'title_ar',
        'description',
        'description_ar',
        'price',
        'currency',
        'condition',
        'attributes',
        'phone',
        'whatsapp',
        'is_boosted',
        'is_featured',
        'views_count',
        'favorites_count',
        'status',
        'published_at',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'attributes' => 'array',
        'is_boosted' => 'boolean',
        'is_featured' => 'boolean',
        'views_count' => 'integer',
        'favorites_count' => 'integer',
        'published_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function subCategory(): BelongsTo
    {
        return $this->belongsTo(Category::class, 'sub_category_id');
    }

    public function country(): BelongsTo
    {
        return $this->belongsTo(Country::class);
    }

    public function city(): BelongsTo
    {
        return $this->belongsTo(City::class);
    }

    public function neighborhood(): BelongsTo
    {
        return $this->belongsTo(Neighborhood::class);
    }

    public function media(): HasMany
    {
        return $this->hasMany(AdMedia::class)->orderBy('pos');
    }

    public function primaryMedia(): HasOne
    {
        return $this->hasOne(AdMedia::class)->where('is_primary', true);
    }

    public function favorites(): HasMany
    {
        return $this->hasMany(Favorite::class);
    }

    public function priceDropAlerts(): HasMany
    {
        return $this->hasMany(PriceDropAlert::class);
    }

    public function getPhotosCountAttribute(): int
    {
        return $this->media()->where('type', 'image')->count();
    }

    public function getVideosCountAttribute(): int
    {
        return $this->media()->where('type', 'video')->count();
    }

    public function getDisplayTitleAttribute(): string
    {
        return app()->getLocale() === 'ar' ? ($this->title_ar ?: $this->title) : $this->title;
    }

    public function getDisplayDescriptionAttribute(): string
    {
        return app()->getLocale() === 'ar' ? ($this->description_ar ?: $this->description) : $this->description;
    }

    public function getDisplayLocationAttribute(): string
    {
        $parts = [];
        if ($this->neighborhood_name) {
            $parts[] = $this->neighborhood_name;
        } elseif ($this->neighborhood) {
            $parts[] = $this->neighborhood->display_name;
        }

        if ($this->city) {
            $parts[] = $this->city->display_name;
        }

        return implode(', ', $parts);
    }

    public function getFormattedPriceAttribute(): string
    {
        $num = number_format($this->price, 0);
        $curr = $this->currency;
        if (app()->getLocale() === 'ar' && $this->country) {
            $curr = $this->country->currency_ar;
        }
        return "{$num} {$curr}";
    }

    public function getTimeAgoAttribute(): string
    {
        if (!$this->published_at) {
            return $this->created_at ? $this->created_at->diffForHumans() : 'Just now';
        }
        return $this->published_at->diffForHumans();
    }
}
