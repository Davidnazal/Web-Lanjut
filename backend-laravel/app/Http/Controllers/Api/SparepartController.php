<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Sparepart;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

/**
 * Class SparepartController
 *
 * Mengelola semua endpoint REST API untuk manajemen data sparepart motor.
 * Menyediakan fungsi CRUD (Create, Read, Update, Delete) serta pencarian dan filter kategori.
 *
 * @package App\Http\Controllers\Api
 */
class SparepartController extends Controller
{
    /**
     * Mengambil daftar semua sparepart dengan dukungan opsi pencarian & filter kategori.
     *
     * Endpoint: GET /api/spareparts
     * Query Parameters:
     * - search (optional): Kata kunci nama sparepart, merk/brand, atau kesesuaian motor.
     * - category (optional): Filter nama kategori sparepart.
     *
     * @param Request $request Request HTTP yang berisi query parameters
     * @return JsonResponse Respons JSON daftar sparepart
     */
    public function index(Request $request): JsonResponse
    {
        $query = Sparepart::query();

        // Filter opsi pencarian berdasarkan nama, brand, atau kesesuaian motor
        if ($request->has('search') && !empty($request->search)) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('part_name', 'like', "%{$search}%")
                  ->orWhere('brand', 'like', "%{$search}%")
                  ->orWhere('compatible_bike', 'like', "%{$search}%");
            });
        }

        // Filter opsi kategori sparepart
        if ($request->has('category') && !empty($request->category) && $request->category !== 'Semua') {
            $query->where('category', $request->category);
        }

        // Urutkan dari data terbaru
        $spareparts = $query->orderBy('id', 'desc')->get();

        return response()->json([
            'status'  => 'success',
            'message' => 'Data sparepart berhasil diambil',
            'data'    => $spareparts,
        ], 200);
    }

    /**
     * Menyimpan data sparepart baru ke dalam database.
     *
     * Endpoint: POST /api/spareparts
     *
     * @param Request $request Request HTTP yang berisi payload data sparepart
     * @return JsonResponse Respons JSON status pembuatan data
     */
    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'part_name'       => 'required|string|max:255',
            'brand'           => 'required|string|max:100',
            'category'        => 'required|string|max:100',
            'compatible_bike' => 'required|string|max:255',
            'price'           => 'required|numeric|min:0',
            'stock'           => 'required|integer|min:0',
            'description'     => 'nullable|string',
        ], [
            'part_name.required' => 'Nama sparepart wajib diisi.',
            'brand.required'     => 'Brand/Merk wajib diisi.',
            'category.required'  => 'Kategori wajib diisi.',
            'price.required'     => 'Harga wajib diisi.',
            'price.numeric'      => 'Harga harus berupa angka.',
            'stock.required'     => 'Stok wajib diisi.',
            'stock.integer'      => 'Stok harus berupa angka bulat.',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Validasi data gagal.',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $sparepart = Sparepart::create($validator->validated());

        return response()->json([
            'status'  => 'success',
            'message' => 'Sparepart berhasil ditambahkan',
            'data'    => $sparepart,
        ], 201);
    }

    /**
     * Menampilkan detail informasi sparepart spesifik berdasarkan ID.
     *
     * Endpoint: GET /api/spareparts/{id}
     *
     * @param int|string $id Identifier unik sparepart
     * @return JsonResponse Respons JSON detail sparepart
     */
    public function show($id): JsonResponse
    {
        $sparepart = Sparepart::find($id);

        if (!$sparepart) {
            return response()->json([
                'status'  => 'error',
                'message' => "Sparepart dengan ID {$id} tidak ditemukan",
            ], 404);
        }

        return response()->json([
            'status'  => 'success',
            'message' => 'Detail sparepart berhasil diambil',
            'data'    => $sparepart,
        ], 200);
    }

    /**
     * Memperbarui data sparepart yang sudah ada di database.
     *
     * Endpoint: PUT/PATCH /api/spareparts/{id}
     *
     * @param Request $request Request HTTP yang berisi payload pembaruan
     * @param int|string $id Identifier unik sparepart yang diubah
     * @return JsonResponse Respons JSON status pembaruan data
     */
    public function update(Request $request, $id): JsonResponse
    {
        $sparepart = Sparepart::find($id);

        if (!$sparepart) {
            return response()->json([
                'status'  => 'error',
                'message' => "Sparepart dengan ID {$id} tidak ditemukan",
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'part_name'       => 'sometimes|required|string|max:255',
            'brand'           => 'sometimes|required|string|max:100',
            'category'        => 'sometimes|required|string|max:100',
            'compatible_bike' => 'sometimes|required|string|max:255',
            'price'           => 'sometimes|required|numeric|min:0',
            'stock'           => 'sometimes|required|integer|min:0',
            'description'     => 'nullable|string',
        ], [
            'part_name.required' => 'Nama sparepart wajib diisi.',
            'brand.required'     => 'Brand/Merk wajib diisi.',
            'price.numeric'      => 'Harga harus berupa angka.',
            'stock.integer'      => 'Stok harus berupa angka bulat.',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => 'error',
                'message' => 'Validasi data gagal.',
                'errors'  => $validator->errors(),
            ], 422);
        }

        $sparepart->update($validator->validated());

        return response()->json([
            'status'  => 'success',
            'message' => 'Sparepart berhasil diperbarui',
            'data'    => $sparepart,
        ], 200);
    }

    /**
     * Menghapus data sparepart dari database berdasarkan ID.
     *
     * Endpoint: DELETE /api/spareparts/{id}
     *
     * @param int|string $id Identifier unik sparepart yang dihapus
     * @return JsonResponse Respons JSON status penghapusan
     */
    public function destroy($id): JsonResponse
    {
        $sparepart = Sparepart::find($id);

        if (!$sparepart) {
            return response()->json([
                'status'  => 'error',
                'message' => "Sparepart dengan ID {$id} tidak ditemukan",
            ], 404);
        }

        $sparepart->delete();

        return response()->json([
            'status'  => 'success',
            'message' => 'Sparepart berhasil dihapus',
        ], 200);
    }
}
