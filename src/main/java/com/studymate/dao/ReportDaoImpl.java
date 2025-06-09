package com.studymate.dao;

import com.studymate.dao.ReportDao;
import com.studymate.model.Report;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReportDaoImpl implements ReportDao {
    private static final String SELECT_ALL = "SELECT * FROM reports ORDER BY created_at DESC";
    private static final String DELETE_BY_ID = "DELETE FROM reports WHERE report_id = ?";

    @Override
    public List<Report> findAll() throws Exception {
        List<Report> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    @Override
    public boolean delete(int reportId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_BY_ID)) {
            ps.setInt(1, reportId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Ánh xạ ResultSet thành Report */
    private Report mapRow(ResultSet rs) throws SQLException {
        Report r = new Report();
        r.setReportId(rs.getInt("report_id"));
        r.setReporterId(rs.getInt("reporter_id"));
        r.setReportedPostId(rs.getInt("reported_post_id"));
        r.setReason(rs.getString("reason"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}
