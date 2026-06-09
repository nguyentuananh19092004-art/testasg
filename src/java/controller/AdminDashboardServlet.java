package controller;

import dal.DashboardDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/AdminDashboardServlet"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        DashboardDAO dao = new DashboardDAO();
        int totalStudents = dao.countTable("HocSinh");
        int totalBuses = dao.countTable("Buses");
        int totalRoutes = dao.countTable("Routes");
        int totalUsers = dao.countTable("Users");

        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalBuses", totalBuses);
        request.setAttribute("totalRoutes", totalRoutes);
        request.setAttribute("totalUsers", totalUsers);

        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
    }
}
