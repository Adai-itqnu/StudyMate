package com.studymate.model;

import java.util.Date;

public class Document {
  private int documentId;
  private int uploaderId;
  private String title;
  private String description;
  private String fileUrl;
  private Date uploadedAt;
  
  // getters & setters...
  public int getDocumentId() {
	return documentId;
}
public void setDocumentId(int documentId) {
	this.documentId = documentId;
}
public int getUploaderId() {
	return uploaderId;
}
public void setUploaderId(int uploaderId) {
	this.uploaderId = uploaderId;
}
public String getTitle() {
	return title;
}
public void setTitle(String title) {
	this.title = title;
}
public String getDescription() {
	return description;
}
public void setDescription(String description) {
	this.description = description;
}
public String getFileUrl() {
	return fileUrl;
}
public void setFileUrl(String fileUrl) {
	this.fileUrl = fileUrl;
}
public Date getUploadedAt() {
	return uploadedAt;
}
public void setUploadedAt(Date uploadedAt) {
	this.uploadedAt = uploadedAt;
}
}