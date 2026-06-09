package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Route;

public class RouteDAO extends DBContext {

    public List<Route> getAllRoutes() {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT * FROM Routes";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Route r = new Route(
                        rs.getInt("RouteID"),
                        rs.getString("RouteCode"),
                        rs.getString("RouteName"),
                        rs.getString("Description")
                );
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
}
