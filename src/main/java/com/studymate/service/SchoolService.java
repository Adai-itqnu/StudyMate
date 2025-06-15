package com.studymate.service;

import com.studymate.model.School;
import java.util.List;

public interface SchoolService {
    List<School> getAllSchools();
    School getSchoolById(int schoolId);
    boolean addSchool(School school);
    boolean updateSchool(School school);
    boolean deleteSchool(int schoolId);
}