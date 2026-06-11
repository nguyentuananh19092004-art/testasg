package controller;

import dal.UserDAO;
import dal.NotificationDAO;
import model.UserLeave;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminInboxServlet", urlPatterns = {"/admin-inbox"})
public class AdminInboxServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        List<UserLeave> pendingLeaves = userDAO.getPendingLeaves();
        
        request.setAttribute("pendingLeaves", pendingLeaves);
        request.getRequestDispatcher("admin_inbox.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        String action = request.getParameter("action");
        int leaveID = Integer.parseInt(request.getParameter("leaveID"));
        
        UserDAO userDAO = new UserDAO();
        NotificationDAO notifDAO = new NotificationDAO();
        
        UserLeave leave = userDAO.getLeaveById(leaveID);
        if (leave == null) {
            response.sendRedirect("admin-inbox?msg=error");
            return;
        }

        // We need the username to send a notification. 
        // We can either add getUsernameById to UserDAO or join it in getLeaveById.
        // Let's quickly add a getUsernameById in UserDAO.
        String username = userDAO.getUsernameById(leave.getUserID());
        
        if ("approve".equals(action)) {
            userDAO.updateLeaveStatus(leaveID, "APPROVED");
            if (username != null) {
                notifDAO.insertNotification(username, "Đơn xin nghỉ phép của bạn vào ngày " + leave.getLeaveDate() + " đã được DUYỆT.");
            }
            response.sendRedirect("admin-inbox?msg=approved");
        } else if ("reject".equals(action)) {
            userDAO.updateLeaveStatus(leaveID, "REJECTED");
            if (username != null) {
                notifDAO.insertNotification(username, "Đơn xin nghỉ phép của bạn vào ngày " + leave.getLeaveDate() + " đã BỊ TỪ CHỐI. Vui lòng liên hệ Admin.");
            }
            response.sendRedirect("admin-inbox?msg=rejected");
        } else {
            response.sendRedirect("admin-inbox");
        }
    }
}
