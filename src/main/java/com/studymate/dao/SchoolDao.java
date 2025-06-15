package com.studymate.dao;

import com.studymate.model.School;
import java.util.List;

public interface SchoolDao {
    List<School> getAllSchools();
    School getSchoolById(int schoolId);
    boolean addSchool(School school);
    boolean updateSchool(School school);
    boolean deleteSchool(int schoolId);
}