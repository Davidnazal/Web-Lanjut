<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Sparepart;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class SparepartController extends Controller
{
    /**
     * Display a listing of the spareparts.
     * GET /api/spareparts
     */
    public function index(Request $request)
    {
        $query = Sparepart::query();

        // Optional Search by Name or Brand
        if ($request->has('search') && !empty($request->search)) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('part_name', 'like', "%{$search}%")
                  ->orWhere('brand', 'like', "%{$search}%")
                  ->orWhere('compatible_bike', 'like', "%{$search}%");
            });
        }

        // Optional Category Filter
        if ($request->has('category') && !empty($request->category) && $request->category !== 'Semua') {
            $query->where('category', $request->category);
        }

        $spareparts = $query->orderBy('id', 'desc')->get();

        return response()->json([
            'status' => 'success',
            'message' => 'Data sparepart berhasil diambil',
            'data' => $spareparts,
        ], 200);
    }

    /**
     * Store a newly created sparepart in storage.
     * POST /api/spareparts
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'part_name' => 'required|string|max:255',
            'brand' => 'required|string|max:100',
            'category' => 'required|string|max:100',
            'compatible_bike' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'description' => 'nullable|string',
        ], [
            'part_name.required' => 'Nama sparepart wajib diisi.',
            'brand.required' => 'Brand/Merk wajib diisi.',
            'category.required' => 'Kategori wajib diisi.',
            'price.required' => 'Harga wajib diisi.',
            'price.numeric' => 'Harga harus berupa angka.',
            'stock.required' => 'Stok wajib diisi.',
            'stock.integer' => 'Stok harus berupa angka bulat.',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'The given data was invalid.',
                'errors' => $validator->errors(),
            ], 422);
        }

        $sparepart = Sparepart::create($validator->validated());

        return response()->json([
            'status' => 'success',
            'message' => 'Sparepart berhasil ditambahkan',
            'data' => $sparepart,
        ], 201);
    }

    /**
     * Display the specified sparepart.
     * GET /api/spareparts/{id}
     */
    public function show($id)
    {
        $sparepart = Sparepart::find($id);

        if (!$sparepart) {
            return response()->json([
                'status' => 'error',
                'message' => "Sparepart dengan ID {$id} tidak ditemukan",
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Detail sparepart berhasil diambil',
            'data' => $sparepart,
        ], 200);
    }

    /**
     * Update the specified sparepart in storage.
     * PUT/PATCH /api/spareparts/{id}
     */
    public function update(Request $request, $id)
    {
        $sparepart = Sparepart::find($id);

        if (!$sparepart) {
            return response()->json([
                'status' => 'error',
                'message' => "Sparepart dengan ID {$id} tidak ditemukan",
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'part_name' => 'sometimes|required|string|max:255',
            'brand' => 'sometimes|required|string|max:100',
            'category' => 'sometimes|required|string|max:100',
            'compatible_bike' => 'sometimes|required|string|max:255',
            'price' => 'sometimes|required|numeric|min:0',
            'stock' => 'sometimes|required|integer|min:0',
            'description' => 'nullable|string',
        ], [
            'part_name.required' => 'Nama sparepart wajib diisi.',
            'brand.required' => 'Brand/Merk wajib diisi.',
            'price.numeric' => 'Harga harus berupa angka.',
            'stock.integer' => 'Stok harus berupa angka bulat.',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'The given data was invalid.',
                'errors' => $validator->errors(),
            ], 422);
        }

        $sparepart->update($validator->validated());

        return response()->json([
            'status' => 'success',
            'message' => 'Sparepart berhasil diperbarui',
            'data' => $sparepart,
        ], 200);
    }

    /**
     * Remove the specified sparepart from storage.
     * DELETE /api/spareparts/{id}
     */
    public function destroy($id)
    {
        $sparepart = Sparepart::find($id);

        if (!$sparepart) {
            return response()->json([
                'status' => 'error',
                'message' => "Sparepart dengan ID {$id} tidak ditemukan",
            ], 404);
        }

        $sparepart->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Sparepart berhasil dihapus',
        ], 200);
    }
}
