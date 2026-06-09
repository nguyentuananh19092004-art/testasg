-- =======================================================
-- Database Script cho Hệ thống School Bus (SQL Server)
-- =======================================================

USE master;
GO

-- Xóa database nếu đã tồn tại
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'SchoolBusDB')
BEGIN
    ALTER DATABASE SchoolBusDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SchoolBusDB;
END
GO

CREATE DATABASE SchoolBusDB;
GO

USE SchoolBusDB;
GO

-- 1. Bảng Users (Tài khoản người dùng: Admin, Parent, Driver, Monitor)
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL, -- Sẽ được hash
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('ADMIN', 'PARENT', 'DRIVER', 'MONITOR')),
    FullName NVARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100)
);

-- 2. Bảng Buses (Thông tin xe)
CREATE TABLE Buses (
    BusID INT IDENTITY(1,1) PRIMARY KEY,
    LicensePlate VARCHAR(20) UNIQUE NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity IN (29, 47)),
    Status VARCHAR(20) DEFAULT 'ACTIVE' -- ACTIVE, MAINTENANCE
);

-- 3. Bảng Routes (Các tuyến đường)
CREATE TABLE Routes (
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    RouteCode VARCHAR(10) UNIQUE NOT NULL, -- LT1, LT2...
    RouteName NVARCHAR(150) NOT NULL,
    Description NVARCHAR(500)
);

-- 4. Bảng Stops (Các điểm dừng/đón)
CREATE TABLE Stops (
    StopID INT IDENTITY(1,1) PRIMARY KEY,
    StopName NVARCHAR(200) NOT NULL,
    Address NVARCHAR(300),
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8)
);

-- 5. Bảng RouteStops (Nối Route và Stop - Thứ tự điểm đón)
CREATE TABLE RouteStops (
    RouteID INT FOREIGN KEY REFERENCES Routes(RouteID),
    StopID INT FOREIGN KEY REFERENCES Stops(StopID),
    StopOrder INT NOT NULL,
    EstimatedTime TIME, -- Giờ đón (chiều đi)
    ReturnTime TIME,    -- Giờ trả (chiều về)
    PRIMARY KEY (RouteID, StopID)
);

-- 6. Bảng HocSinh (Thông tin học sinh)
CREATE TABLE HocSinh (
    MaHocSinh VARCHAR(20) PRIMARY KEY,
    TenHocSinh NVARCHAR(100) NOT NULL,
    Lop INT CHECK (Lop BETWEEN 1 AND 5),
    TenTK VARCHAR(50) UNIQUE NOT NULL,
    MatKhau VARCHAR(255) DEFAULT '1',
    TrangThai NVARCHAR(20) DEFAULT N'Sử dụng'
);

-- 7. Bảng Schedules (Lịch chạy hàng ngày)
CREATE TABLE Schedules (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    Date DATE NOT NULL,
    Direction VARCHAR(10) NOT NULL CHECK (Direction IN ('TO_SCHOOL', 'TO_HOME')),
    RouteID INT FOREIGN KEY REFERENCES Routes(RouteID),
    BusID INT FOREIGN KEY REFERENCES Buses(BusID),
    DriverID INT FOREIGN KEY REFERENCES Users(UserID),
    MonitorID INT FOREIGN KEY REFERENCES Users(UserID),
    Status VARCHAR(20) DEFAULT 'PENDING' -- PENDING, IN_PROGRESS, COMPLETED, CANCELLED
);

-- 8. Bảng Attendances (Điểm danh lên/xuống xe)
CREATE TABLE Attendances (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    ScheduleID INT FOREIGN KEY REFERENCES Schedules(ScheduleID),
    MaHocSinh VARCHAR(20) FOREIGN KEY REFERENCES HocSinh(MaHocSinh),
    StopID INT FOREIGN KEY REFERENCES Stops(StopID), -- Điểm thực tế đón/trả
    BoardingTime DATETIME, -- Thời gian lên xe
    AlightingTime DATETIME, -- Thời gian xuống xe
    IsAbsent BIT DEFAULT 0, -- 1: Đã báo nghỉ hoặc vắng mặt
    Note NVARCHAR(255)
);

GO
-- =======================================================
-- INSERT DỮ LIỆU MẪU (SEED DATA)
-- =======================================================

-- 1. Insert Users
INSERT INTO Users (Username, Password, Role, FullName, Phone) VALUES
('admin', '123456', 'ADMIN', N'Quản trị viên', '0900000001'),
('giamsat1', '123456', 'MONITOR', N'Trần Thị Giám Sát', '0900000002'),
('taixe1', '123456', 'DRIVER', N'Nguyễn Văn Tài Xế', '0900000003'),
('phuhuynh1', '123456', 'PARENT', N'Lê Văn Phụ Huynh', '0900000004');

-- 2. Insert Buses
INSERT INTO Buses (LicensePlate, Capacity) VALUES
('29E-111.11', 29),
('29E-222.22', 47),
('29E-333.33', 29);

-- 3. Insert Routes (Tất cả 6 tuyến xe)
INSERT INTO Routes (RouteCode, RouteName) VALUES
('LT1', N'Ocean Park -> LandMark 72 -> Trường học'),
('LT2', N'VinCom Long Biên -> Royal City -> Trường học'),
('LT3', N'Vincom Metropolis -> Phạm Hùng -> Trường học'),
('LT4', N'Minh Tảo -> 6th elements -> Trường học'),
('LT5', N'Ecohome 3 -> Vinhome gardenia -> Trường học'),
('LT6', N'Victory Văn Phú -> Matrix One -> Trường học');

-- 4. Insert Stops (Chỉ bao gồm các điểm đón học sinh và Trường học, bỏ qua các tuyến đường đi qua)
INSERT INTO Stops (StopName) VALUES
(N'S2.15 (Ocean Park)'),          -- 1
(N'S1.08 (Ocean Park)'),          -- 2
(N'The Zen Gamuda'),              -- 3
(N'LandMark 72'),                 -- 4
(N'Trường Marie Curie'),          -- 5
(N'VinCom Long Biên'),            -- 6
(N'H3 Chu Huy Mân'),              -- 7
(N'423 Minh Khai'),               -- 8
(N'VinCom TimesCity'),            -- 9
(N'Royal City'),                  -- 10
(N'Vincom Metropolis'),           -- 11
(N'VinCom Nguyễn Chí Thanh'),     -- 12
(N'N03-T1 Minh Tảo'),             -- 13
(N'N01-T6'),                      -- 14
(N'6th elements'),                -- 15
(N'Tòa N02, Ecohome 3'),          -- 16
(N'27A2 thành phố giao lưu'),     -- 17
(N'R1 GoldMark City'),            -- 18
(N'A1 Vinhome gardenia'),         -- 19
(N'V3 Victory Văn Phú'),          -- 20
(N'P2 ParkCity'),                 -- 21
(N'C16 Gleximco'),                -- 22
(N'A32 Gleximco'),                -- 23
(N'GS1 SmartCity'),               -- 24
(N'S401 SmartCity'),              -- 25
(N'Mỹ Đình Pearl'),               -- 26
(N'Matrix One');                  -- 27

-- 5. Insert RouteStops
-- Tuyến LT1
INSERT INTO RouteStops (RouteID, StopID, StopOrder, EstimatedTime, ReturnTime) VALUES
(1, 1, 1, '06:40', '17:50'),
(1, 2, 2, '06:50', '17:40'),
(1, 3, 3, '07:10', '17:20'),
(1, 4, 4, '07:40', '16:50'),
(1, 5, 5, '08:00', '16:30');

-- Tuyến LT2
INSERT INTO RouteStops (RouteID, StopID, StopOrder, EstimatedTime, ReturnTime) VALUES
(2, 6, 1, '06:40', '17:50'),
(2, 7, 2, '06:50', '17:40'),
(2, 8, 3, '07:05', '17:25'),
(2, 9, 4, '07:15', '17:15'),
(2, 10, 5, '07:40', '16:50'),
(2, 5, 6, '08:00', '16:30');

-- Tuyến LT3
INSERT INTO RouteStops (RouteID, StopID, StopOrder, EstimatedTime, ReturnTime) VALUES
(3, 11, 1, '07:15', '17:15'),
(3, 12, 2, '07:30', '17:00'),
(3, 5, 3, '08:00', '16:30');

-- Tuyến LT4
INSERT INTO RouteStops (RouteID, StopID, StopOrder, EstimatedTime, ReturnTime) VALUES
(4, 13, 1, '07:00', '17:30'),
(4, 14, 2, '07:15', '17:15'),
(4, 15, 3, '07:30', '17:00'),
(4, 5, 4, '08:00', '16:30');

-- Tuyến LT5
INSERT INTO RouteStops (RouteID, StopID, StopOrder, EstimatedTime, ReturnTime) VALUES
(5, 16, 1, '06:50', '17:40'),
(5, 17, 2, '07:10', '17:20'),
(5, 18, 3, '07:25', '17:05'),
(5, 19, 4, '07:40', '16:50'),
(5, 5, 5, '08:00', '16:30');

-- Tuyến LT6
INSERT INTO RouteStops (RouteID, StopID, StopOrder, EstimatedTime, ReturnTime) VALUES
(6, 20, 1, '07:00', '17:30'),
(6, 21, 2, '07:07', '17:23'),
(6, 22, 3, '07:15', '17:15'),
(6, 23, 4, '07:22', '17:08'),
(6, 24, 5, '07:30', '17:00'),
(6, 25, 6, '07:37', '16:53'),
(6, 26, 7, '07:45', '16:45'),
(6, 27, 8, '07:52', '16:38'),
(6, 5, 9, '08:00', '16:30');

-- 6. Insert HocSinh (100 học sinh, 20 hs mỗi lớp từ 1 đến 5)
INSERT INTO HocSinh (MaHocSinh, TenHocSinh, Lop, TenTK, MatKhau, TrangThai) VALUES
('L1001', N'Nguyễn Văn A1', 1, 'A1NVL1001', '1', N'Sử dụng'), ('L1002', N'Nguyễn Văn A2', 1, 'A2NVL1002', '1', N'Sử dụng'), ('L1003', N'Nguyễn Văn A3', 1, 'A3NVL1003', '1', N'Sử dụng'), ('L1004', N'Nguyễn Văn A4', 1, 'A4NVL1004', '1', N'Sử dụng'), ('L1005', N'Nguyễn Văn A5', 1, 'A5NVL1005', '1', N'Sử dụng'),
('L1006', N'Nguyễn Văn A6', 1, 'A6NVL1006', '1', N'Sử dụng'), ('L1007', N'Nguyễn Văn A7', 1, 'A7NVL1007', '1', N'Sử dụng'), ('L1008', N'Nguyễn Văn A8', 1, 'A8NVL1008', '1', N'Sử dụng'), ('L1009', N'Nguyễn Văn A9', 1, 'A9NVL1009', '1', N'Sử dụng'), ('L1010', N'Nguyễn Văn A10', 1, 'A10NVL1010', '1', N'Sử dụng'),
('L1011', N'Nguyễn Văn A11', 1, 'A11NVL1011', '1', N'Sử dụng'), ('L1012', N'Nguyễn Văn A12', 1, 'A12NVL1012', '1', N'Sử dụng'), ('L1013', N'Nguyễn Văn A13', 1, 'A13NVL1013', '1', N'Sử dụng'), ('L1014', N'Nguyễn Văn A14', 1, 'A14NVL1014', '1', N'Sử dụng'), ('L1015', N'Nguyễn Văn A15', 1, 'A15NVL1015', '1', N'Sử dụng'),
('L1016', N'Nguyễn Văn A16', 1, 'A16NVL1016', '1', N'Sử dụng'), ('L1017', N'Nguyễn Văn A17', 1, 'A17NVL1017', '1', N'Sử dụng'), ('L1018', N'Nguyễn Văn A18', 1, 'A18NVL1018', '1', N'Sử dụng'), ('L1019', N'Nguyễn Văn A19', 1, 'A19NVL1019', '1', N'Sử dụng'), ('L1020', N'Nguyễn Văn A20', 1, 'A20NVL1020', '1', N'Sử dụng'),
('L2001', N'Trần Thị B1', 2, 'B1TTL2001', '1', N'Sử dụng'), ('L2002', N'Trần Thị B2', 2, 'B2TTL2002', '1', N'Sử dụng'), ('L2003', N'Trần Thị B3', 2, 'B3TTL2003', '1', N'Sử dụng'), ('L2004', N'Trần Thị B4', 2, 'B4TTL2004', '1', N'Sử dụng'), ('L2005', N'Trần Thị B5', 2, 'B5TTL2005', '1', N'Sử dụng'),
('L2006', N'Trần Thị B6', 2, 'B6TTL2006', '1', N'Sử dụng'), ('L2007', N'Trần Thị B7', 2, 'B7TTL2007', '1', N'Sử dụng'), ('L2008', N'Trần Thị B8', 2, 'B8TTL2008', '1', N'Sử dụng'), ('L2009', N'Trần Thị B9', 2, 'B9TTL2009', '1', N'Sử dụng'), ('L2010', N'Trần Thị B10', 2, 'B10TTL2010', '1', N'Sử dụng'),
('L2011', N'Trần Thị B11', 2, 'B11TTL2011', '1', N'Sử dụng'), ('L2012', N'Trần Thị B12', 2, 'B12TTL2012', '1', N'Sử dụng'), ('L2013', N'Trần Thị B13', 2, 'B13TTL2013', '1', N'Sử dụng'), ('L2014', N'Trần Thị B14', 2, 'B14TTL2014', '1', N'Sử dụng'), ('L2015', N'Trần Thị B15', 2, 'B15TTL2015', '1', N'Sử dụng'),
('L2016', N'Trần Thị B16', 2, 'B16TTL2016', '1', N'Sử dụng'), ('L2017', N'Trần Thị B17', 2, 'B17TTL2017', '1', N'Sử dụng'), ('L2018', N'Trần Thị B18', 2, 'B18TTL2018', '1', N'Sử dụng'), ('L2019', N'Trần Thị B19', 2, 'B19TTL2019', '1', N'Sử dụng'), ('L2020', N'Trần Thị B20', 2, 'B20TTL2020', '1', N'Sử dụng'),
('L3001', N'Lê Văn C1', 3, 'C1LVL3001', '1', N'Sử dụng'), ('L3002', N'Lê Văn C2', 3, 'C2LVL3002', '1', N'Sử dụng'), ('L3003', N'Lê Văn C3', 3, 'C3LVL3003', '1', N'Sử dụng'), ('L3004', N'Lê Văn C4', 3, 'C4LVL3004', '1', N'Sử dụng'), ('L3005', N'Lê Văn C5', 3, 'C5LVL3005', '1', N'Sử dụng'),
('L3006', N'Lê Văn C6', 3, 'C6LVL3006', '1', N'Sử dụng'), ('L3007', N'Lê Văn C7', 3, 'C7LVL3007', '1', N'Sử dụng'), ('L3008', N'Lê Văn C8', 3, 'C8LVL3008', '1', N'Sử dụng'), ('L3009', N'Lê Văn C9', 3, 'C9LVL3009', '1', N'Sử dụng'), ('L3010', N'Lê Văn C10', 3, 'C10LVL3010', '1', N'Sử dụng'),
('L3011', N'Lê Văn C11', 3, 'C11LVL3011', '1', N'Sử dụng'), ('L3012', N'Lê Văn C12', 3, 'C12LVL3012', '1', N'Sử dụng'), ('L3013', N'Lê Văn C13', 3, 'C13LVL3013', '1', N'Sử dụng'), ('L3014', N'Lê Văn C14', 3, 'C14LVL3014', '1', N'Sử dụng'), ('L3015', N'Lê Văn C15', 3, 'C15LVL3015', '1', N'Sử dụng'),
('L3016', N'Lê Văn C16', 3, 'C16LVL3016', '1', N'Sử dụng'), ('L3017', N'Lê Văn C17', 3, 'C17LVL3017', '1', N'Sử dụng'), ('L3018', N'Lê Văn C18', 3, 'C18LVL3018', '1', N'Sử dụng'), ('L3019', N'Lê Văn C19', 3, 'C19LVL3019', '1', N'Sử dụng'), ('L3020', N'Lê Văn C20', 3, 'C20LVL3020', '1', N'Sử dụng'),
('L4001', N'Phạm Thị D1', 4, 'D1PTL4001', '1', N'Sử dụng'), ('L4002', N'Phạm Thị D2', 4, 'D2PTL4002', '1', N'Sử dụng'), ('L4003', N'Phạm Thị D3', 4, 'D3PTL4003', '1', N'Sử dụng'), ('L4004', N'Phạm Thị D4', 4, 'D4PTL4004', '1', N'Sử dụng'), ('L4005', N'Phạm Thị D5', 4, 'D5PTL4005', '1', N'Sử dụng'),
('L4006', N'Phạm Thị D6', 4, 'D6PTL4006', '1', N'Sử dụng'), ('L4007', N'Phạm Thị D7', 4, 'D7PTL4007', '1', N'Sử dụng'), ('L4008', N'Phạm Thị D8', 4, 'D8PTL4008', '1', N'Sử dụng'), ('L4009', N'Phạm Thị D9', 4, 'D9PTL4009', '1', N'Sử dụng'), ('L4010', N'Phạm Thị D10', 4, 'D10PTL4010', '1', N'Sử dụng'),
('L4011', N'Phạm Thị D11', 4, 'D11PTL4011', '1', N'Sử dụng'), ('L4012', N'Phạm Thị D12', 4, 'D12PTL4012', '1', N'Sử dụng'), ('L4013', N'Phạm Thị D13', 4, 'D13PTL4013', '1', N'Sử dụng'), ('L4014', N'Phạm Thị D14', 4, 'D14PTL4014', '1', N'Sử dụng'), ('L4015', N'Phạm Thị D15', 4, 'D15PTL4015', '1', N'Sử dụng'),
('L4016', N'Phạm Thị D16', 4, 'D16PTL4016', '1', N'Sử dụng'), ('L4017', N'Phạm Thị D17', 4, 'D17PTL4017', '1', N'Sử dụng'), ('L4018', N'Phạm Thị D18', 4, 'D18PTL4018', '1', N'Sử dụng'), ('L4019', N'Phạm Thị D19', 4, 'D19PTL4019', '1', N'Sử dụng'), ('L4020', N'Phạm Thị D20', 4, 'D20PTL4020', '1', N'Sử dụng'),
('L5001', N'Hoàng Văn E1', 5, 'E1HVL5001', '1', N'Sử dụng'), ('L5002', N'Hoàng Văn E2', 5, 'E2HVL5002', '1', N'Sử dụng'), ('L5003', N'Hoàng Văn E3', 5, 'E3HVL5003', '1', N'Sử dụng'), ('L5004', N'Hoàng Văn E4', 5, 'E4HVL5004', '1', N'Sử dụng'), ('L5005', N'Hoàng Văn E5', 5, 'E5HVL5005', '1', N'Sử dụng'),
('L5006', N'Hoàng Văn E6', 5, 'E6HVL5006', '1', N'Sử dụng'), ('L5007', N'Hoàng Văn E7', 5, 'E7HVL5007', '1', N'Sử dụng'), ('L5008', N'Hoàng Văn E8', 5, 'E8HVL5008', '1', N'Sử dụng'), ('L5009', N'Hoàng Văn E9', 5, 'E9HVL5009', '1', N'Sử dụng'), ('L5010', N'Hoàng Văn E10', 5, 'E10HVL5010', '1', N'Sử dụng'),
('L5011', N'Hoàng Văn E11', 5, 'E11HVL5011', '1', N'Sử dụng'), ('L5012', N'Hoàng Văn E12', 5, 'E12HVL5012', '1', N'Sử dụng'), ('L5013', N'Hoàng Văn E13', 5, 'E13HVL5013', '1', N'Sử dụng'), ('L5014', N'Hoàng Văn E14', 5, 'E14HVL5014', '1', N'Sử dụng'), ('L5015', N'Hoàng Văn E15', 5, 'E15HVL5015', '1', N'Sử dụng'),
('L5016', N'Hoàng Văn E16', 5, 'E16HVL5016', '1', N'Sử dụng'), ('L5017', N'Hoàng Văn E17', 5, 'E17HVL5017', '1', N'Sử dụng'), ('L5018', N'Hoàng Văn E18', 5, 'E18HVL5018', '1', N'Sử dụng'), ('L5019', N'Hoàng Văn E19', 5, 'E19HVL5019', '1', N'Sử dụng'), ('L5020', N'Hoàng Văn E20', 5, 'E20HVL5020', '1', N'Sử dụng');

-- 7. Insert Schedule (Ngày hiện tại)
INSERT INTO Schedules (Date, Direction, RouteID, BusID, DriverID, MonitorID, Status) VALUES
(CAST(GETDATE() AS DATE), 'TO_SCHOOL', 1, 1, 3, 2, 'PENDING'),
(CAST(GETDATE() AS DATE), 'TO_HOME',   1, 1, 3, 2, 'PENDING');

-- 8. Insert Attendances (Khởi tạo sẵn danh sách điểm danh cho chuyến xe trên)
-- Lấy ID của Schedule vừa tạo là 1 (TO_SCHOOL) và 2 (TO_HOME)
INSERT INTO Attendances (ScheduleID, MaHocSinh, StopID, IsAbsent) VALUES
(1, 'L1001', 1, 0),
(1, 'L1002', 2, 0),
(2, 'L1001', 1, 0),
(2, 'L1002', 2, 0);

GO
PRINT 'Database Setup Completed successfully.';
