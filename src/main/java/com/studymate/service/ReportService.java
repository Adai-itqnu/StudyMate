package com.studymate.service;

import com.studymate.model.Report;
import java.util.List;

public interface ReportService {
    /**
     * Lấy danh sách tất cả báo cáo
     */
    List<Report> findAll() throws Exception;

    /**
     * Xóa báo cáo theo ID
     */
    boolean delete(int reportId) throws Exception;
}