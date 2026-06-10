package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet(name = "UserUpdateServlet", urlPatterns = {"/user-update"})
public class UserUpdateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        UserDAO dao = new UserDAO();
        User u = dao.getUserById(id);
        
        request.setAttribute("userObj", u);
        request.setAttribute("role", u.getRole());
        request.getRequestDispatcher("user_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        int userID = Integer.parseInt(request.getParameter("userID"));
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        UserDAO dao = new UserDAO();
        User existingUser = dao.getUserById(userID);
        String password = existingUser.getPassword(); // retain password

        if (dao.checkUsernameExist(username, userID)) {
            request.setAttribute("error", "Tên tài khoản '" + username + "' đã được sử dụng!");
            request.setAttribute("userObj", new User(userID, username, password, role, fullName, phone, email, status));
            request.setAttribute("role", role);
            request.getRequestDispatcher("user_form.jsp").forward(request, response);
            return;
        }

        User u = new User(userID, username, password, role, fullName, phone, email, status);
        dao.updateUser(u);

        response.sendRedirect("user-list?role=" + role);
    }
}
