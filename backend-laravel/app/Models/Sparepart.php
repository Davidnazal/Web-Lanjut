<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Sparepart extends Model
{
    use HasFactory;

    protected $fillable = [
        'part_name',
        'brand',
        'category',
        'compatible_bike',
        'price',
        'stock',
        'description',
    ];

    protected $casts = [
        'price' => 'float',
        'stock' => 'integer',
    ];
}
