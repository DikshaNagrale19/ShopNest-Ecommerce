<?php
// ============================================================
//  config/constants.php — App-wide constants
// ============================================================

define('APP_NAME',     getenv('APP_NAME') ?: 'ShopNest');
define('APP_URL',      rtrim(getenv('APP_URL') ?: 'http://localhost/aws-ecommerce', '/'));
define('APP_ENV',      getenv('APP_ENV')  ?: 'development');
define('APP_DEBUG',    getenv('APP_DEBUG') === 'true');

// Currency
define('CURRENCY_SYMBOL', '₹');
define('CURRENCY_CODE',   'INR');

// Pagination
define('PRODUCTS_PER_PAGE', 12);
define('ORDERS_PER_PAGE',   10);
define('ADMIN_PER_PAGE',    15);

// Upload limits
define('MAX_UPLOAD_SIZE',   5 * 1024 * 1024); // 5 MB
define('ALLOWED_IMG_TYPES', ['image/jpeg', 'image/png', 'image/webp', 'image/gif']);
define('UPLOAD_DIR',        __DIR__ . '/../uploads/products/');

// Order statuses
define('ORDER_STATUSES', ['pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded']);

// Payment methods
define('PAYMENT_METHODS', ['cod' => 'Cash on Delivery', 'upi' => 'UPI', 'card' => 'Credit/Debit Card', 'netbanking' => 'Net Banking']);

// Session keys
define('SESSION_USER',  'ecom_user');
define('SESSION_ADMIN', 'ecom_admin');
define('SESSION_CART',  'ecom_cart');

// Paths
define('BASE_DIR', __DIR__ . '/..');
