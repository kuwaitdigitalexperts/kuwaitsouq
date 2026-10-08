<?php

namespace App\Models;

use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Relations\HasMany;

class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'phone',
        'phone_code',
        'password',
        'avatar',
        'is_admin',
        'is_verified',
        'member_type',
        'member_id_number',
        'member_since',
        'live_listings_limit',
        'rating',
        'rating_count',
        'listing_credits',
        'vas_credits',
        'cv_completeness',
        'cv_views',
        'job_applications_count',
        'member_views',
        'whatsapp',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'member_since' => 'date',
            'password' => 'hashed',
            'is_admin' => 'boolean',
            'is_verified' => 'boolean',
            'rating' => 'float',
            'rating_count' => 'integer',
            'listing_credits' => 'integer',
            'vas_credits' => 'integer',
            'live_listings_limit' => 'integer',
            'cv_completeness' => 'integer',
            'cv_views' => 'integer',
            'job_applications_count' => 'integer',
            'member_views' => 'integer',
        ];
    }

    public function ads(): HasMany
    {
        return $this->hasMany(Ad::class);
    }

    public function stories(): HasMany
    {
        return $this->hasMany(SellerStory::class);
    }

    public function favorites(): HasMany
    {
        return $this->hasMany(Favorite::class);
    }

    public function savedSearches(): HasMany
    {
        return $this->hasMany(SavedSearch::class);
    }

    public function sentMessages(): HasMany
    {
        return $this->hasMany(Message::class, 'sender_id');
    }

    public function receivedMessages(): HasMany
    {
        return $this->hasMany(Message::class, 'receiver_id');
    }

    public function getActiveAdsCountAttribute(): int
    {
        return $this->ads()->where('status', 'active')->count();
    }
}
