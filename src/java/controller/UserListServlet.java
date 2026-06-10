package controller;

import dal.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet(name = "UserListServlet", urlPatterns = {"/user-list"})
public class UserListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role"); // DRIVER or MONITOR
        if (role == null || role.isEmpty()) {
            role = "DRIVER"; // default
        }
        
        UserDAO dao = new UserDAO();
        List<User> userList = dao.getUsersByRole(role);
        
        request.setAttribute("userList", userList);
        request.setAttribute("role", role);
        request.getRequestDispatcher("user_list.jsp").forward(request, response);
    }
}
