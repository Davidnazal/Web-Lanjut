<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Sparepart
 *
 * Representasi model database Eloquent untuk entitas Sparepart Motor.
 *
 * @property int $id ID unik sparepart
 * @property string $part_name Nama produk sparepart
 * @property string $brand Merk/Brand produsen
 * @property string $category Kategori sparepart (Knalpot, Pengereman, Mesin, dll)
 * @property string $compatible_bike Jenis/tipe motor yang cocok
 * @property float $price Harga sparepart dalam Rupiah
 * @property int $stock Jumlah stok ketersediaan unit
 * @property string|null $description Deskripsi rinci spesifikasi produk
 * @property \Illuminate\Support\Carbon|null $created_at Waktu pembuatan data
 * @property \Illuminate\Support\Carbon|null $updated_at Waktu pembaruan data
 *
 * @package App\Models
 */
class Sparepart extends Model
{
    use HasFactory;

    /**
     * Atribut yang dapat diisi secara massal (mass assignable).
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'part_name',
        'brand',
        'category',
        'compatible_bike',
        'price',
        'stock',
        'description',
    ];

    /**
     * Tipe data casting untuk atribut Eloquent.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'price' => 'float',
        'stock' => 'integer',
    ];
}
