<?php

namespace Database\Seeders;

use App\Models\Sparepart;
use Illuminate\Database\Seeder;

class SparepartSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $parts = [
            [
                'part_name' => 'Knalpot Aeromax Carbon Full System',
                'brand' => 'Aeromax',
                'category' => 'Knalpot',
                'compatible_bike' => 'Yamaha Vixion Old Gen 2 (2011)',
                'price' => 1250000,
                'stock' => 5,
                'description' => 'Knalpot racing Aeromax full system stainless carbon header. Suara bass adem bulat, meningkatkan akselerasi Vixion Old tanpa ganti settingan ekstrem.',
            ],
            [
                'part_name' => 'Kaliper Rem RCB / Racepro 2 Piston',
                'brand' => 'RCB / Racepro',
                'category' => 'Pengereman',
                'compatible_bike' => 'Yamaha Vixion Old (Depan)',
                'price' => 650000,
                'stock' => 8,
                'description' => 'Kaliper pengereman RCB / Racepro 2 piston CNC anodized. Memberikan daya cengkeram rem depan yang jauh lebih pakem dan responsif.',
            ],
            [
                'part_name' => 'Velg Racing VND Six Star / AK 55',
                'brand' => 'VND',
                'category' => 'Ban & Velg',
                'compatible_bike' => 'Yamaha Vixion Old Gen 2 (2011)',
                'price' => 1650000,
                'stock' => 3,
                'description' => 'Velg racing alumunium alloy palang 6 presisi tinggi. Berbobot ringan dan kokoh untuk kenyamanan harian maupun touring.',
            ],
            [
                'part_name' => 'Radiator Alumunium B-Pro Big Volume',
                'brand' => 'B-Pro Racing',
                'category' => 'Mesin',
                'compatible_bike' => 'Yamaha Vixion Old (2007-2012)',
                'price' => 950000,
                'stock' => 4,
                'description' => 'Radiator gambul B-Pro berbahan alumunium kapasitas lebih besar. Efektif menjaga suhu mesin Vixion tetap adem saat kemacetan atau perjalanan jauh.',
            ],
            [
                'part_name' => 'Master Rem Radial Daytona 14mm',
                'brand' => 'Daytona',
                'category' => 'Pengereman',
                'compatible_bike' => 'Yamaha Vixion Old / Universal',
                'price' => 450000,
                'stock' => 10,
                'description' => 'Master rem radial Daytona handle lipat. Tuas empuk dan respon pengereman sangat presisi untuk harian.',
            ],
            [
                'part_name' => 'Ban Aspira Premio Sportivo 2 (110/70-17)',
                'brand' => 'Aspira Premio',
                'category' => 'Ban & Velg',
                'compatible_bike' => 'Yamaha Vixion Old Gen 2 (2011)',
                'price' => 580000,
                'stock' => 12,
                'description' => 'Ban tubeless sport harian kompon medium-soft. Memberikan grip maksimal saat manuver di jalanan basah maupun kering.',
            ],
        ];

        foreach ($parts as $part) {
            Sparepart::create($part);
        }
    }
}
