package com.studymate.dao;

import com.studymate.model.Report;
import java.util.List;

public interface ReportDao {
    /** Lấy danh sách tất cả báo cáo */
    List<Report> findAll() throws Exception;
    /** Xóa báo cáo theo ID */
    boolean delete(int reportId) throws Exception;
}
