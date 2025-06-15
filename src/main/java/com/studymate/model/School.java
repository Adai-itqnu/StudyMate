package com.studymate.model;

public class School {
    private int schoolId;
    private String name;

    // Constructors
    public School() {}

    public School(int schoolId, String name) {
        this.schoolId = schoolId;
        this.name = name;
    }

    public School(String name) {
        this.name = name;
    }

    // Getters and Setters
    public int getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(int schoolId) {
        this.schoolId = schoolId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // toString method
    @Override
    public String toString() {
        return "School{" +
                "schoolId=" + schoolId +
                ", name='" + name + '\'' +
                '}';
    }

    // equals and hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        School school = (School) o;
        return schoolId == school.schoolId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(schoolId);
    }
}