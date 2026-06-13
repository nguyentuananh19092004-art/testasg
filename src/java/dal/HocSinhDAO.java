package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.HocSinh;

public class HocSinhDAO extends DBContext {

    public List<HocSinh> getAllHocSinh() {
        List<HocSinh> list = new ArrayList<>();
        String sql = "SELECT * FROM HocSinh";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                HocSinh hs = new HocSinh(
                        rs.getString("MaHocSinh"),
                        rs.getString("TenHocSinh"),
                        rs.getInt("Lop"),
                        rs.getString("TenTK"),
                        rs.getString("MatKhau"),
                        rs.getObject("DefaultStopID") != null ? rs.getInt("DefaultStopID") : null,
                        rs.getObject("DefaultRouteID") != null ? rs.getInt("DefaultRouteID") : null,
                        rs.getString("TrangThai")
                );
                list.add(hs);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public HocSinh getHocSinhByMa(String maHocSinh) {
        String sql = "SELECT * FROM HocSinh WHERE MaHocSinh = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, maHocSinh);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new HocSinh(
                        rs.getString("MaHocSinh"),
                        rs.getString("TenHocSinh"),
                        rs.getInt("Lop"),
                        rs.getString("TenTK"),
                        rs.getString("MatKhau"),
                        rs.getObject("DefaultStopID") != null ? rs.getInt("DefaultStopID") : null,
                        rs.getObject("DefaultRouteID") != null ? rs.getInt("DefaultRouteID") : null,
                        rs.getString("TrangThai")
                );
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public HocSinh getHocSinhByTenTK(String tenTK) {
        String sql = "SELECT * FROM HocSinh WHERE TenTK = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, tenTK);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new HocSinh(
                        rs.getString("MaHocSinh"),
                        rs.getString("TenHocSinh"),
                        rs.getInt("Lop"),
                        rs.getString("TenTK"),
                        rs.getString("MatKhau"),
                        rs.getObject("DefaultStopID") != null ? rs.getInt("DefaultStopID") : null,
                        rs.getObject("DefaultRouteID") != null ? rs.getInt("DefaultRouteID") : null,
                        rs.getString("TrangThai")
                );
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public List<HocSinh> getHocSinhByStopID(int stopID) {
        List<HocSinh> list = new ArrayList<>();
        String sql = "SELECT * FROM HocSinh WHERE DefaultStopID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, stopID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new HocSinh(
                        rs.getString("MaHocSinh"),
                        rs.getString("TenHocSinh"),
                        rs.getInt("Lop"),
                        rs.getString("TenTK"),
                        rs.getString("MatKhau"),
                        rs.getObject("DefaultStopID") != null ? rs.getInt("DefaultStopID") : null,
                        rs.getObject("DefaultRouteID") != null ? rs.getInt("DefaultRouteID") : null,
                        rs.getString("TrangThai")
                ));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public void insertHocSinh(HocSinh hs) {
        String sql = "INSERT INTO HocSinh (MaHocSinh, TenHocSinh, Lop, TenTK, MatKhau, DefaultStopID, DefaultRouteID, TrangThai) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, hs.getMaHocSinh());
            st.setString(2, hs.getTenHocSinh());
            st.setInt(3, hs.getLop());
            st.setString(4, hs.getTenTK());
            st.setString(5, hs.getMatKhau());
            if (hs.getDefaultStopID() != null) {
                st.setInt(6, hs.getDefaultStopID());
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }
            if (hs.getDefaultRouteID() != null) {
                st.setInt(7, hs.getDefaultRouteID());
            } else {
                st.setNull(7, java.sql.Types.INTEGER);
            }
            st.setString(8, hs.getTrangThai());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void updateHocSinh(HocSinh hs) {
        String sql = "UPDATE HocSinh SET TenHocSinh = ?, Lop = ?, TenTK = ?, MatKhau = ?, DefaultStopID = ?, DefaultRouteID = ?, TrangThai = ? WHERE MaHocSinh = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, hs.getTenHocSinh());
            st.setInt(2, hs.getLop());
            st.setString(3, hs.getTenTK());
            st.setString(4, hs.getMatKhau());
            if (hs.getDefaultStopID() != null) {
                st.setInt(5, hs.getDefaultStopID());
            } else {
                st.setNull(5, java.sql.Types.INTEGER);
            }
            if (hs.getDefaultRouteID() != null) {
                st.setInt(6, hs.getDefaultRouteID());
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }
            st.setString(7, hs.getTrangThai());
            st.setString(8, hs.getMaHocSinh());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void stopService(String maHocSinh) {
        String sql = "UPDATE HocSinh SET TrangThai = N'Ngưng hoạt động', DefaultStopID = NULL, DefaultRouteID = NULL WHERE MaHocSinh = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, maHocSinh);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteHocSinh(String maHocSinh) {
        // Lưu ý: Nếu có liên kết với bảng Attendances, có thể cần xóa ở bảng con trước
        String sql = "DELETE FROM HocSinh WHERE MaHocSinh = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, maHocSinh);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public boolean checkLogin(String tenTK, String matKhau) {
        String sql = "SELECT * FROM HocSinh WHERE TenTK = ? AND MatKhau = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, tenTK);
            st.setString(2, matKhau);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public int countActiveHocSinhByRoute(int routeID) {
        String sql = "SELECT COUNT(*) FROM HocSinh WHERE DefaultRouteID = ? AND TrangThai = N'Sử dụng'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, routeID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return 0;
    }
}
