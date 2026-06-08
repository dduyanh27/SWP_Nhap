-- Script tạo tài khoản Admin để test dashboard
-- Chạy script này trên database VMFruitDB (SQL Server)

-- 1. Tạo role ADMIN nếu chưa có
IF NOT EXISTS (SELECT 1 FROM Roles WHERE role_name = 'ADMIN')
BEGIN
    INSERT INTO Roles (role_name, description)
    VALUES ('ADMIN', 'Administrator with full system access');
END

-- 2. Tạo user admin (password: admin123 - đã hash BCrypt)
-- Nếu email admin@vmfruit.com chưa tồn tại
IF NOT EXISTS (SELECT 1 FROM Users WHERE email = 'admin@vmfruit.com')
BEGIN
    DECLARE @adminUserId INT;

    INSERT INTO Users (full_name, email, password_hash, phone, status, created_at)
    VALUES (
        N'Admin VMFruit',
        'admin@vmfruit.com',
        -- BCrypt hash của "admin123"
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        '0123456789',
        'ACTIVE',
        GETDATE()
    );

    SET @adminUserId = SCOPE_IDENTITY();

    -- 3. Gán role ADMIN cho user
    INSERT INTO UserRoles (user_id, role_id)
    VALUES (@adminUserId, (SELECT role_id FROM Roles WHERE role_name = 'ADMIN'));

    -- 4. Tạo giỏ hàng cho admin (nếu bắt buộc)
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Carts')
    BEGIN
        INSERT INTO Carts (user_id, created_at, updated_at)
        VALUES (@adminUserId, GETDATE(), GETDATE());
    END

    PRINT N'Tạo tài khoản admin thành công!';
END
ELSE
BEGIN
    PRINT N'Email admin@vmfruit.com đã tồn tại, bỏ qua.';
END

-- Kiểm tra
SELECT u.user_id, u.full_name, u.email, r.role_name
FROM Users u
JOIN UserRoles ur ON u.user_id = ur.user_id
JOIN Roles r ON ur.role_id = r.role_id
WHERE r.role_name = 'ADMIN';
