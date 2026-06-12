USE SchoolBusDB;
GO

UPDATE Stops SET Latitude = 20.9934, Longitude = 105.9427 WHERE StopID = 1;  -- S2.15 (Ocean Park)
UPDATE Stops SET Latitude = 20.9980, Longitude = 105.9450 WHERE StopID = 2;  -- S1.08 (Ocean Park)
UPDATE Stops SET Latitude = 20.9658, Longitude = 105.8679 WHERE StopID = 3;  -- The Zen Gamuda
UPDATE Stops SET Latitude = 21.0173, Longitude = 105.7841 WHERE StopID = 4;  -- LandMark 72
UPDATE Stops SET Latitude = 21.0175, Longitude = 105.7808 WHERE StopID = 5;  -- Trường Marie Curie
UPDATE Stops SET Latitude = 21.0401, Longitude = 105.9189 WHERE StopID = 6;  -- VinCom Long Biên
UPDATE Stops SET Latitude = 21.0345, Longitude = 105.9123 WHERE StopID = 7;  -- H3 Chu Huy Mân
UPDATE Stops SET Latitude = 20.9981, Longitude = 105.8654 WHERE StopID = 8;  -- 423 Minh Khai
UPDATE Stops SET Latitude = 20.9954, Longitude = 105.8675 WHERE StopID = 9;  -- VinCom TimesCity
UPDATE Stops SET Latitude = 21.0028, Longitude = 105.8155 WHERE StopID = 10; -- Royal City
UPDATE Stops SET Latitude = 21.0317, Longitude = 105.8143 WHERE StopID = 11; -- Vincom Metropolis
UPDATE Stops SET Latitude = 21.0244, Longitude = 105.8088 WHERE StopID = 12; -- VinCom Nguyễn Chí Thanh
UPDATE Stops SET Latitude = 21.0664, Longitude = 105.7950 WHERE StopID = 13; -- N03-T1 Minh Tảo
UPDATE Stops SET Latitude = 21.0682, Longitude = 105.7941 WHERE StopID = 14; -- N01-T6
UPDATE Stops SET Latitude = 21.0573, Longitude = 105.8005 WHERE StopID = 15; -- 6th elements
UPDATE Stops SET Latitude = 21.0772, Longitude = 105.7831 WHERE StopID = 16; -- Tòa N02, Ecohome 3
UPDATE Stops SET Latitude = 21.0543, Longitude = 105.7803 WHERE StopID = 17; -- 27A2 thành phố giao lưu
UPDATE Stops SET Latitude = 21.0396, Longitude = 105.7656 WHERE StopID = 18; -- R1 GoldMark City
UPDATE Stops SET Latitude = 21.0342, Longitude = 105.7635 WHERE StopID = 19; -- A1 Vinhome gardenia
UPDATE Stops SET Latitude = 20.9572, Longitude = 105.7644 WHERE StopID = 20; -- V3 Victory Văn Phú
UPDATE Stops SET Latitude = 20.9665, Longitude = 105.7533 WHERE StopID = 21; -- P2 ParkCity
UPDATE Stops SET Latitude = 20.9882, Longitude = 105.7421 WHERE StopID = 22; -- C16 Gleximco
UPDATE Stops SET Latitude = 20.9950, Longitude = 105.7455 WHERE StopID = 23; -- A32 Gleximco
UPDATE Stops SET Latitude = 21.0084, Longitude = 105.7483 WHERE StopID = 24; -- GS1 SmartCity
UPDATE Stops SET Latitude = 21.0062, Longitude = 105.7451 WHERE StopID = 25; -- S401 SmartCity
UPDATE Stops SET Latitude = 21.0093, Longitude = 105.7744 WHERE StopID = 26; -- Mỹ Đình Pearl
UPDATE Stops SET Latitude = 21.0116, Longitude = 105.7766 WHERE StopID = 27; -- Matrix One

PRINT 'Cập nhật tọa độ 27 trạm dừng thành công!';
GO
