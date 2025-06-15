package com.studymate.service.impl;

import com.studymate.dao.SchoolDao;
import com.studymate.dao.impl.SchoolDaoImpl;
import com.studymate.model.School;
import com.studymate.service.SchoolService;

import java.util.List;

public class SchoolServiceImpl implements SchoolService {

    private final SchoolDao schoolDao;

    public SchoolServiceImpl() {
        this.schoolDao = new SchoolDaoImpl(); 
    }

    @Override
    public List<School> getAllSchools() {
        try {
            List<School> schools = schoolDao.getAllSchools();
            System.out.println("SchoolService: Retrieved " + (schools != null ? schools.size() : 0) + " schools");
            return schools;
        } catch (Exception e) {
            System.err.println("Error getting all schools: " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>(); // Return empty list instead of null
        }
    }

    @Override
    public School getSchoolById(int schoolId) {
        try {
            if (schoolId <= 0) {
                System.out.println("SchoolService: Invalid school ID: " + schoolId);
                return null;
            }
            
            School school = schoolDao.getSchoolById(schoolId);
            System.out.println("SchoolService: Retrieved school with ID " + schoolId + ": " + 
                             (school != null ? school.getName() : "null"));
            return school;
        } catch (Exception e) {
            System.err.println("Error getting school by id " + schoolId + ": " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean addSchool(School school) {
        try {
            if (school == null || school.getName() == null || school.getName().trim().isEmpty()) {
                System.err.println("SchoolService: Invalid school data");
                return false;
            }
            
            boolean result = schoolDao.addSchool(school);
            System.out.println("SchoolService: Add school result: " + result);
            return result;
        } catch (Exception e) {
            System.err.println("Error adding school: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateSchool(School school) {
        try {
            if (school == null || school.getSchoolId() <= 0 || 
                school.getName() == null || school.getName().trim().isEmpty()) {
                System.err.println("SchoolService: Invalid school data for update");
                return false;
            }
            
            boolean result = schoolDao.updateSchool(school);
            System.out.println("SchoolService: Update school result: " + result);
            return result;
        } catch (Exception e) {
            System.err.println("Error updating school: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteSchool(int schoolId) {
        try {
            if (schoolId <= 0) {
                System.err.println("SchoolService: Invalid school ID for deletion: " + schoolId);
                return false;
            }
            
            boolean result = schoolDao.deleteSchool(schoolId);
            System.out.println("SchoolService: Delete school result: " + result);
            return result;
        } catch (Exception e) {
            System.err.println("Error deleting school: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}