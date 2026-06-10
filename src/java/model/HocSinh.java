package model;

public class HocSinh {
    private String maHocSinh;
    private String tenHocSinh;
    private int lop;
    private String tenTK;
    private String matKhau;
    private Integer defaultStopID;
    private String trangThai;

    public HocSinh() {
    }

    public HocSinh(String maHocSinh, String tenHocSinh, int lop, String tenTK, String matKhau, Integer defaultStopID, String trangThai) {
        this.maHocSinh = maHocSinh;
        this.tenHocSinh = tenHocSinh;
        this.lop = lop;
        this.tenTK = tenTK;
        this.matKhau = matKhau;
        this.defaultStopID = defaultStopID;
        this.trangThai = trangThai;
    }

    public String getMaHocSinh() {
        return maHocSinh;
    }

    public void setMaHocSinh(String maHocSinh) {
        this.maHocSinh = maHocSinh;
    }

    public String getTenHocSinh() {
        return tenHocSinh;
    }

    public void setTenHocSinh(String tenHocSinh) {
        this.tenHocSinh = tenHocSinh;
    }

    public int getLop() {
        return lop;
    }

    public void setLop(int lop) {
        this.lop = lop;
    }

    public String getTenTK() {
        return tenTK;
    }

    public void setTenTK(String tenTK) {
        this.tenTK = tenTK;
    }

    public String getMatKhau() {
        return matKhau;
    }

    public void setMatKhau(String matKhau) {
        this.matKhau = matKhau;
    }

    public Integer getDefaultStopID() {
        return defaultStopID;
    }

    public void setDefaultStopID(Integer defaultStopID) {
        this.defaultStopID = defaultStopID;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }
}
