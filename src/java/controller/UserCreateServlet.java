package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet(name = "UserCreateServlet", urlPatterns = {"/user-create"})
public class UserCreateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        request.setAttribute("role", role);
        request.getRequestDispatcher("user_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String password = "123"; // Default password for new staff

        UserDAO dao = new UserDAO();
        if (dao.checkUsernameExist(username, 0)) {
            request.setAttribute("error", "Tên tài khoản '" + username + "' đã tồn tại!");
            request.setAttribute("userObj", new User(0, username, password, role, fullName, phone, email, status));
            request.setAttribute("role", role);
            request.getRequestDispatcher("user_form.jsp").forward(request, response);
            return;
        }

        if (dao.checkPhoneExist(phone, 0)) {
            request.setAttribute("error", "Số điện thoại '" + phone + "' đã được người khác sử dụng!");
            request.setAttribute("userObj", new User(0, username, password, role, fullName, phone, email, status));
            request.setAttribute("role", role);
            request.getRequestDispatcher("user_form.jsp").forward(request, response);
            return;
        }

        User u = new User(0, username, password, role, fullName, phone, email, status);
        dao.insertUser(u);

        response.sendRedirect("user-list?role=" + role);
    }
}
