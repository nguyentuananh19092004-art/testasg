USE SchoolBusDB;
GO

-- Xóa bảng nếu đã tồn tại để an toàn khi chạy lại
IF OBJECT_ID('TechnicianSchedules', 'U') IS NOT NULL
    DROP TABLE TechnicianSchedules;
GO

CREATE TABLE TechnicianSchedules (
    TechScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    TechnicianID INT FOREIGN KEY REFERENCES Users(UserID),
    Date DATE NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UNIQUE (TechnicianID, Date)
);
GO
