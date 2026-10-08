<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AdMedia extends Model
{
    protected $fillable = [
        'ad_id',
        'type',
        'file_path',
        'is_primary',
        'pos',
    ];

    protected $casts = [
        'is_primary' => 'boolean',
        'pos' => 'integer',
    ];

    public function ad(): BelongsTo
    {
        return $this->belongsTo(Ad::class);
    }
}
