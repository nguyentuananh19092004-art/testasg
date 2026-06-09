package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu người dùng truy cập trực tiếp /LoginServlet bằng GET, chuyển hướng về trang đăng nhập
        response.sendRedirect("dang_nhap.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy thông tin từ form
        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        String dbRole = "";
        if ("admin".equals(role)) dbRole = "ADMIN";
        else if ("giamthi".equals(role)) dbRole = "MONITOR";
        else if ("phuhuynh".equals(role)) dbRole = "PARENT";
        else if ("taixe".equals(role)) dbRole = "DRIVER";
        
        dal.UserDAO userDAO = new dal.UserDAO();
        boolean isValid = userDAO.checkLogin(username, password, dbRole);
        
        if (isValid) {
            HttpSession session = request.getSession();
            session.setAttribute("userRole", role);
            session.setAttribute("username", username);
            
            // Chuyển hướng dựa theo role
            if ("admin".equals(role)) {
                response.sendRedirect("AdminDashboardServlet");
            } else if ("giamthi".equals(role)) {
                response.sendRedirect("giamthi_dashboard.jsp");
            } else if ("phuhuynh".equals(role)) {
                response.sendRedirect("phuhuynh_dashboard.jsp");
            } else if ("taixe".equals(role)) {
                response.sendRedirect("taixe_dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            // Đăng nhập thất bại, quay lại trang login kèm thông báo lỗi
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("dang_nhap.jsp").forward(request, response);
        }
    }
}
