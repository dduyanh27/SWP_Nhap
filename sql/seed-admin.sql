-- Seed admin account
-- Run this in SSMS on VMFruitDB

-- 1. Tạo role ADMIN nếu chưa có
IF NOT EXISTS (SELECT 1 FROM Roles WHERE role_name = 'ADMIN')
BEGIN
    INSERT INTO Roles (role_name, description)
    VALUES ('ADMIN', 'Administrator with full system access');
END

-- 2. Tạo role CUSTOMER nếu chưa có
IF NOT EXISTS (SELECT 1 FROM Roles WHERE role_name = 'CUSTOMER')
BEGIN
    INSERT INTO Roles (role_name, description)
    VALUES ('CUSTOMER', 'Customer');
END

-- 3. Tạo user admin (phone: 0123456789, password: admin123)
IF NOT EXISTS (SELECT 1 FROM Users WHERE phone = '0123456789')
BEGIN
    DECLARE @adminUserId INT;

    INSERT INTO Users (full_name, email, password_hash, phone, status, created_at)
    VALUES (
        N'Admin VMFruit',
        'admin@vmfruit.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        '0123456789',
        'ACTIVE',
        GETDATE()
    );

    SET @adminUserId = SCOPE_IDENTITY();

    -- Gán role ADMIN
    INSERT INTO UserRoles (user_id, role_id)
    VALUES (@adminUserId, (SELECT role_id FROM Roles WHERE role_name = 'ADMIN'));

    -- Tạo giỏ hàng cho admin
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Carts')
    BEGIN
        INSERT INTO Carts (user_id, created_at, updated_at)
        VALUES (@adminUserId, GETDATE(), GETDATE());
    END

    PRINT N'Tạo tài khoản admin thành công!';
END
ELSE
BEGIN
    PRINT N'Số điện thoại 0123456789 đã tồn tại, bỏ qua.';
END
