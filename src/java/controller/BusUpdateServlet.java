package controller;

import dal.BusDAO;
import model.Bus;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BusUpdateServlet", urlPatterns = {"/bus-update"})
public class BusUpdateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        try {
            int id = Integer.parseInt(idRaw);
            BusDAO dao = new BusDAO();
            Bus bus = dao.getBusById(id);
            request.setAttribute("bus", bus);
            request.getRequestDispatcher("bus_form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("bus-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            int busID = Integer.parseInt(request.getParameter("busID"));
            String licensePlate = request.getParameter("licensePlate");
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            String status = request.getParameter("status");

            BusDAO dao = new BusDAO();
            if (dao.checkLicensePlateExist(licensePlate, busID)) {
                request.setAttribute("error", "Biển số xe '" + licensePlate + "' đã được sử dụng bởi xe khác!");
                request.setAttribute("bus", new Bus(busID, licensePlate, capacity, status));
                request.getRequestDispatcher("bus_form.jsp").forward(request, response);
                return;
            }

            Bus b = new Bus(busID, licensePlate, capacity, status);
            dao.updateBus(b);
        } catch (Exception e) {
            System.out.println(e);
        }

        response.sendRedirect("bus-list");
    }
}
