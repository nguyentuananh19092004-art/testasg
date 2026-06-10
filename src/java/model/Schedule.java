package model;

import java.sql.Date;

public class Schedule {
    private int scheduleID;
    private Date date;
    private String direction;
    private int routeID;
    private int busID;
    private int driverID;
    private int monitorID;
    private String status;
    private String incidentStatus;

    // Các đối tượng liên kết (để hiển thị chi tiết ra View)
    private Route route;
    private Bus bus;
    private User driver;
    private User monitor;

    public Schedule() {
    }

    public Schedule(int scheduleID, Date date, String direction, int routeID, int busID, int driverID, int monitorID, String status, String incidentStatus) {
        this.scheduleID = scheduleID;
        this.date = date;
        this.direction = direction;
        this.routeID = routeID;
        this.busID = busID;
        this.driverID = driverID;
        this.monitorID = monitorID;
        this.status = status;
        this.incidentStatus = incidentStatus;
    }

    public int getScheduleID() {
        return scheduleID;
    }

    public void setScheduleID(int scheduleID) {
        this.scheduleID = scheduleID;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public int getRouteID() {
        return routeID;
    }

    public void setRouteID(int routeID) {
        this.routeID = routeID;
    }

    public int getBusID() {
        return busID;
    }

    public void setBusID(int busID) {
        this.busID = busID;
    }

    public int getDriverID() {
        return driverID;
    }

    public void setDriverID(int driverID) {
        this.driverID = driverID;
    }

    public int getMonitorID() {
        return monitorID;
    }

    public void setMonitorID(int monitorID) {
        this.monitorID = monitorID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getIncidentStatus() {
        return incidentStatus;
    }

    public void setIncidentStatus(String incidentStatus) {
        this.incidentStatus = incidentStatus;
    }

    public Route getRoute() {
        return route;
    }

    public void setRoute(Route route) {
        this.route = route;
    }

    public Bus getBus() {
        return bus;
    }

    public void setBus(Bus bus) {
        this.bus = bus;
    }

    public User getDriver() {
        return driver;
    }

    public void setDriver(User driver) {
        this.driver = driver;
    }

    public User getMonitor() {
        return monitor;
    }

    public void setMonitor(User monitor) {
        this.monitor = monitor;
    }
}
