import re

def update_db():
    with open('SchoolBusDB.sql', 'r', encoding='utf-8') as f:
        content = f.read()

    # Add DefaultStopID to HocSinh
    if 'DefaultStopID INT FOREIGN KEY' not in content:
        content = re.sub(
            r"(MatKhau VARCHAR\(255\) DEFAULT '123',)",
            r"\1\n    DefaultStopID INT FOREIGN KEY REFERENCES Stops(StopID),",
            content
        )

    # Add IncidentStatus to Schedules
    if 'IncidentStatus VARCHAR(20)' not in content:
        content = re.sub(
            r"(Status VARCHAR\(20\) DEFAULT 'PENDING')(.*?)(;?\s*\n\);)",
            r"\1,\n    IncidentStatus VARCHAR(20) DEFAULT 'NORMAL'\3",
            content,
            flags=re.DOTALL
        )

    # Add ScheduleProgress and Notifications tables
    if 'CREATE TABLE ScheduleProgress' not in content:
        new_tables = """

-- 9. Bảng ScheduleProgress (Tiến trình chuyến đi)
CREATE TABLE ScheduleProgress (
    ProgressID INT IDENTITY(1,1) PRIMARY KEY,
    ScheduleID INT FOREIGN KEY REFERENCES Schedules(ScheduleID),
    StopID INT FOREIGN KEY REFERENCES Stops(StopID),
    ArrivalTime DATETIME NOT NULL
);

-- 10. Bảng Notifications (Thông báo)
CREATE TABLE Notifications (
    NotifID INT IDENTITY(1,1) PRIMARY KEY,
    Username VARCHAR(50) FOREIGN KEY REFERENCES Users(Username),
    Message NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsRead BIT DEFAULT 0
);
"""
        content = re.sub(
            r"(Note NVARCHAR\(255\)\s*\n\);)\s*GO",
            r"\1" + new_tables + "\nGO",
            content
        )

    with open('SchoolBusDB.sql', 'w', encoding='utf-8') as f:
        f.write(content)
    print("Database schema successfully patched.")

if __name__ == '__main__':
    update_db()
