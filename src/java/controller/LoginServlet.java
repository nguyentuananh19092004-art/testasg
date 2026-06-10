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
        response.sendRedirect("dang_nhap.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        dal.UserDAO userDAO = new dal.UserDAO();
        String role = null;
        
        if (userDAO.checkLogin(username, password, "ADMIN")) role = "admin";
        else if (userDAO.checkLogin(username, password, "MONITOR")) role = "giamthi";
        else if (userDAO.checkLogin(username, password, "PARENT")) role = "phuhuynh";
        else if (userDAO.checkLogin(username, password, "DRIVER")) role = "taixe";
        else if (userDAO.checkLogin(username, password, "TECHNICIAN")) role = "kythuat";
        
        boolean isValid = (role != null);
        
        if (!isValid) {
            dal.HocSinhDAO hocSinhDAO = new dal.HocSinhDAO();
            if (hocSinhDAO.checkLogin(username, password)) {
                isValid = true;
                role = "phuhuynh";
            }
        }
        
        if (isValid) {
            HttpSession session = request.getSession();
            session.setAttribute("userRole", role);
            session.setAttribute("username", username);
            
            if ("admin".equals(role)) {
                response.sendRedirect("AdminDashboardServlet");
            } else if ("giamthi".equals(role)) {
                response.sendRedirect("giamthi_dashboard.jsp");
            } else if ("phuhuynh".equals(role)) {
                response.sendRedirect("phuhuynh_dashboard.jsp");
            } else if ("taixe".equals(role)) {
                response.sendRedirect("taixe_dashboard.jsp");
            } else if ("kythuat".equals(role)) {
                response.sendRedirect("kythuat_dashboard.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Ten dang nhap hoac mat khau khong dung!");
            request.getRequestDispatcher("dang_nhap.jsp").forward(request, response);
        }
    }
}
