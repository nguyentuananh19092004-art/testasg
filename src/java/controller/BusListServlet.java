package controller;

import dal.BusDAO;
import model.Bus;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BusListServlet", urlPatterns = {"/bus-list"})
public class BusListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BusDAO dao = new BusDAO();
        List<Bus> list = dao.getAllBuses();
        
        request.setAttribute("busList", list);
        request.getRequestDispatcher("bus_list.jsp").forward(request, response);
    }
}
