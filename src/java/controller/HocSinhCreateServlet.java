package controller;

import dal.HocSinhDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.HocSinh;

@WebServlet(name = "HocSinhCreateServlet", urlPatterns = {"/hocsinh-add"})
public class HocSinhCreateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("hocsinh_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String maHocSinh = request.getParameter("maHocSinh");
        String tenHocSinh = request.getParameter("tenHocSinh");
        String lopStr = request.getParameter("lop");
        String tenTK = request.getParameter("tenTK");
        String matKhau = request.getParameter("matKhau");
        String trangThai = request.getParameter("trangThai");

        int lop = 1;
        try {
            lop = Integer.parseInt(lopStr);
        } catch (NumberFormatException e) {
        }

        HocSinh hs = new HocSinh(maHocSinh, tenHocSinh, lop, tenTK, matKhau, trangThai);
        HocSinhDAO dao = new HocSinhDAO();
        dao.insertHocSinh(hs);

        response.sendRedirect("hocsinh-list");
    }
}
