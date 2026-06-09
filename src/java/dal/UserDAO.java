package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserDAO extends DBContext {

    public List<User> getUsersByRole(String role) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Role = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, role);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(
                        rs.getInt("UserID"),
                        rs.getString("Username"),
                        rs.getString("Password"),
                        rs.getString("Role"),
                        rs.getString("FullName"),
                        rs.getString("Phone"),
                        rs.getString("Email")
                );
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
}
