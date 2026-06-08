-- Table for storing password reset tokens
-- Run this script against your VMFruitDB database

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'password_reset_tokens')
BEGIN
    CREATE TABLE password_reset_tokens (
        id INT IDENTITY(1,1) PRIMARY KEY,
        token NVARCHAR(255) NOT NULL UNIQUE,
        user_id INT NOT NULL,
        expiry_date DATETIME2 NOT NULL,
        used BIT NOT NULL DEFAULT 0,
        CONSTRAINT FK_password_reset_tokens_Users FOREIGN KEY (user_id) REFERENCES dbo.Users(user_id)
    );

    CREATE INDEX IX_password_reset_tokens_token ON password_reset_tokens(token);
    CREATE INDEX IX_password_reset_tokens_user_id ON password_reset_tokens(user_id);
END
