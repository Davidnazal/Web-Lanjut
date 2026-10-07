<?php

// CORS Headers for Flutter & Web Clients
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('Content-Type: application/json; charset=UTF-8');

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Database Connection (SQLite)
$isVercel = isset($_ENV['VERCEL']) || isset($_SERVER['VERCEL']) || (defined('PHP_OS_FAMILY') && PHP_OS_FAMILY !== 'Windows' && file_exists('/tmp'));
$dbDir = $isVercel ? '/tmp' : __DIR__ . '/../database';

if (!file_exists($dbDir)) {
    @mkdir($dbDir, 0777, true);
}

$dbPath = $dbDir . '/database.sqlite';
try {
    $pdo = new PDO('sqlite:' . $dbPath);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

    // Auto Migration
    $pdo->exec("CREATE TABLE IF NOT EXISTS spareparts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        part_name TEXT NOT NULL,
        brand TEXT NOT NULL,
        category TEXT NOT NULL,
        compatible_bike TEXT DEFAULT 'Yamaha Vixion Old Gen 2 (2011)',
        price REAL NOT NULL,
        stock INTEGER NOT NULL DEFAULT 0,
        description TEXT,
        image_url TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )");

    // Ensure image_url column exists if table was created previously
    try {
        $pdo->exec("ALTER TABLE spareparts ADD COLUMN image_url TEXT");
    } catch (Exception $ignored) {
        // Column already exists
    }

    // Auto Seed ONLY if table is empty (Never delete existing user edits/items!)
    $count = $pdo->query("SELECT COUNT(*) FROM spareparts")->fetchColumn();
    if ($count == 0) {
        $stmt = $pdo->prepare("INSERT INTO spareparts (part_name, brand, category, compatible_bike, price, stock, description, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        $initialParts = [
            [
                'Ban Aspira Premio Sportivo 2 (110/70-17)',
                'Aspira Premio',
                'Ban & Velg',
                'Yamaha Vixion Old Gen 2 (2011)',
                580000,
                12,
                'Ban tubeless sport harian kompon medium-soft. Grip maksimal di jalan basah dan kering.',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSridFmTP_OD5ujJ3gqEYS3UP20RDl_pphywRtmk-LkUndsTZn1gcDtPE&s=10'
            ],
            [
                'Master Rem Daytona 17mm',
                'Daytona',
                'Pengereman',
                'Yamaha Vixion Old / Universal',
                450000,
                10,
                'Master rem radial Daytona 17mm handle lipat. Tuas empuk dan respon pengereman sangat presisi untuk harian.',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvoTVDVoBzMsusISp7x-Kl8vHoCKflFXVSHnV5jDGFE5l4gJOPjUjLiHg&s=10'
            ],
            [
                'Radiator B-Pro Big Vixion',
                'B-Pro Racing',
                'Mesin',
                'Yamaha Vixion Old (2007-2012)',
                950000,
                4,
                'Radiator gambul B-Pro berbahan alumunium kapasitas lebih besar. Efektif menjaga suhu mesin Vixion tetap dingin.',
                'https://down-id.img.susercontent.com/file/id-11134207-822wj-mloh7jpfsydd5e'
            ],
            [
                'Velg VND AK55 Ring 17 Vixion',
                'VND',
                'Ban & Velg',
                'Yamaha Vixion Old Gen 2 (2011)',
                1650000,
                3,
                'Velg racing alumunium alloy VND AK55 ring 17 palang presisi tinggi. Berbobot ringan dan kokoh.',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTESVQn1Aj45Do-edWQ8eH0HnHT2TRH99Zj_3s0fwYYS6rqlK95TcIzzByZ&s=10'
            ],
            [
                'Kaliper 4 Piston RCB',
                'RCB',
                'Pengereman',
                'Yamaha Vixion Old (Depan)',
                650000,
                8,
                'Kaliper 4 piston RCB CNC anodized. Memberikan daya cengkeram rem depan yang jauh lebih pakem.',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIP4OHZU3svZ4uADVrZnPRmjABVjlv7_iq9tQJg6PV9zGZfpWb_9gwxr5B&s=10'
            ],
            [
                'Knalpot Aeromax Carbon Full System',
                'Aeromax',
                'Knalpot',
                'Yamaha Vixion Old Gen 2 (2011)',
                1250000,
                5,
                'Knalpot racing Aeromax full system stainless carbon header. Suara bass adem bulat, meningkatkan akselerasi Vixion Old.',
                'https://down-id.img.susercontent.com/file/id-11134207-82250-mkjwsud41sso06'
            ],
        ];

        foreach ($initialParts as $p) {
            $stmt->execute($p);
        }
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Database connection failed: ' . $e->getMessage()
    ]);
    exit();
}

// Helper Response Function
function sendJson($status, $message, $data = null, $code = 200, $errors = null) {
    http_response_code($code);
    $res = ['status' => $status, 'message' => $message];
    if ($data !== null) $res['data'] = $data;
    if ($errors !== null) $res['errors'] = $errors;
    echo json_encode($res, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    exit();
}

// Router Parser
$uri = parse_url($_SERVER['REQUEST_URI'] ?? '/api/spareparts', PHP_URL_PATH);

// Standardize route path
$uri = rtrim($uri, '/');
if (strpos($uri, '/api/spareparts') !== 0) {
    sendJson('error', 'Endpoint API tidak ditemukan', null, 404);
}

$idParam = null;
$parts = explode('/', $uri);
if (count($parts) >= 4 && is_numeric($parts[3])) {
    $idParam = (int)$parts[3];
}

// --- ROUTE HANDLERS ---

// 1. GET /api/spareparts OR /api/spareparts/{id}
if ($method === 'GET') {
    if ($idParam !== null) {
        // GET DETAIL
        $stmt = $pdo->prepare("SELECT * FROM spareparts WHERE id = ?");
        $stmt->execute([$idParam]);
        $item = $stmt->fetch();
        if ($item) {
            sendJson('success', 'Detail sparepart berhasil diambil', $item, 200);
        } else {
            sendJson('error', "Sparepart dengan ID {$idParam} tidak ditemukan", null, 404);
        }
    } else {
        // GET LIST
        $search = $_GET['search'] ?? '';
        $category = $_GET['category'] ?? '';

        $sql = "SELECT * FROM spareparts WHERE 1=1";
        $params = [];

        if (!empty($search)) {
            $sql .= " AND (part_name LIKE ? OR brand LIKE ? OR compatible_bike LIKE ?)";
            $params[] = "%$search%";
            $params[] = "%$search%";
            $params[] = "%$search%";
        }

        if (!empty($category) && $category !== 'Semua') {
            $sql .= " AND category = ?";
            $params[] = $category;
        }

        $sql .= " ORDER BY id DESC";
        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $items = $stmt->fetchAll();

        sendJson('success', 'Data sparepart berhasil diambil', $items, 200);
    }
}

// Read JSON Input Body
$inputJSON = file_get_contents('php://input');
$body = json_decode($inputJSON, true) ?? $_POST;

// 2. POST /api/spareparts
if ($method === 'POST') {
    $errors = [];
    if (empty($body['part_name'])) $errors['part_name'] = ['Nama sparepart wajib diisi.'];
    if (empty($body['brand'])) $errors['brand'] = ['Brand/Merk wajib diisi.'];
    if (empty($body['category'])) $errors['category'] = ['Kategori wajib diisi.'];
    if (!isset($body['price']) || !is_numeric($body['price']) || $body['price'] < 0) {
        $errors['price'] = ['Harga wajib diisi dan harus berupa angka positif.'];
    }
    if (!isset($body['stock']) || !is_numeric($body['stock']) || $body['stock'] < 0) {
        $errors['stock'] = ['Stok wajib diisi dan harus berupa angka bulat.'];
    }

    if (!empty($errors)) {
        sendJson('error', 'The given data was invalid.', null, 422, $errors);
    }

    $stmt = $pdo->prepare("INSERT INTO spareparts (part_name, brand, category, compatible_bike, price, stock, description, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->execute([
        $body['part_name'],
        $body['brand'],
        $body['category'],
        $body['compatible_bike'] ?? 'Yamaha Vixion Old Gen 2 (2011)',
        (float)$body['price'],
        (int)$body['stock'],
        $body['description'] ?? '',
        $body['image_url'] ?? ''
    ]);

    $newId = $pdo->lastInsertId();
    $newItem = $pdo->query("SELECT * FROM spareparts WHERE id = $newId")->fetch();

    sendJson('success', 'Sparepart berhasil ditambahkan', $newItem, 201);
}

// 3. PUT / PATCH /api/spareparts/{id}
if (($method === 'PUT' || $method === 'PATCH') && $idParam !== null) {
    $stmt = $pdo->prepare("SELECT * FROM spareparts WHERE id = ?");
    $stmt->execute([$idParam]);
    $existing = $stmt->fetch();

    if (!$existing) {
        sendJson('error', "Sparepart dengan ID {$idParam} tidak ditemukan", null, 404);
    }

    $part_name = $body['part_name'] ?? $existing['part_name'];
    $brand = $body['brand'] ?? $existing['brand'];
    $category = $body['category'] ?? $existing['category'];
    $compatible_bike = $body['compatible_bike'] ?? $existing['compatible_bike'];
    $price = isset($body['price']) ? (float)$body['price'] : (float)$existing['price'];
    $stock = isset($body['stock']) ? (int)$body['stock'] : (int)$existing['stock'];
    $description = $body['description'] ?? $existing['description'];
    $image_url = $body['image_url'] ?? $existing['image_url'];

    $stmtUpdate = $pdo->prepare("UPDATE spareparts SET part_name=?, brand=?, category=?, compatible_bike=?, price=?, stock=?, description=?, image_url=?, updated_at=CURRENT_TIMESTAMP WHERE id=?");
    $stmtUpdate->execute([$part_name, $brand, $category, $compatible_bike, $price, $stock, $description, $image_url, $idParam]);

    $updatedItem = $pdo->query("SELECT * FROM spareparts WHERE id = $idParam")->fetch();
    sendJson('success', 'Sparepart berhasil diperbarui', $updatedItem, 200);
}

// 4. DELETE /api/spareparts/{id}
if ($method === 'DELETE' && $idParam !== null) {
    $stmt = $pdo->prepare("SELECT * FROM spareparts WHERE id = ?");
    $stmt->execute([$idParam]);
    $existing = $stmt->fetch();

    if (!$existing) {
        sendJson('error', "Sparepart dengan ID {$idParam} tidak ditemukan", null, 404);
    }

    $pdo->prepare("DELETE FROM spareparts WHERE id = ?")->execute([$idParam]);
    sendJson('success', 'Sparepart berhasil dihapus', null, 200);
}

sendJson('error', 'Method HTTP tidak didukung', null, 405);
