package com.studymate.service.impl;

import com.studymate.dao.ReportDao;
import com.studymate.dao.impl.ReportDaoImpl;
import com.studymate.model.Report;
import com.studymate.service.ReportService;
import java.util.List;

public class ReportServiceImpl implements ReportService {
    private final ReportDao reportDao = new ReportDaoImpl();

    @Override
    public List<Report> findAll() throws Exception {
        return reportDao.findAll();
    }

    @Override
    public boolean delete(int reportId) throws Exception {
        return reportDao.delete(reportId);
    }
}
